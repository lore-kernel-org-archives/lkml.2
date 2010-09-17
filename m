Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0IQRof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 13:44:35 -0400
Received: from mail.tpi.com ([70.99.223.143]:3622 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600Ab0IQRoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 13:44:34 -0400
Message-ID: <4C93A8F9.9090108@canonical.com>
Date: Fri, 17 Sep 2010 11:44:25 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100826 Thunderbird/3.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org, Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>
Subject: Re: [PATCH] staging: brcm80211: Make CFLAGS explicit
References: <1284736810-2940-1-git-send-email-tim.gardner@canonical.com> <20100917162142.GA30385@suse.de>
In-Reply-To: <20100917162142.GA30385@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2010 10:21 AM, Greg KH wrote:
> On Fri, Sep 17, 2010 at 09:20:10AM -0600, Tim Gardner wrote:
>> Its too easy to confuse the obscurely named WLC_LOW/WLC_HIGH CFLAG
>> macros.
>
> True, but doesn't this change how the code is being built?  Why make
> this change?
>
>>
>> Signed-off-by: Tim Gardner<tim.gardner@canonical.com>
>> Cc: Brett Rudley<brudley@broadcom.com>
>> Cc: Henry Ptasinski<henryp@broadcom.com>
>> Cc: Nohee Ko<noheek@broadcom.com>
>> ---
>>   drivers/staging/brcm80211/Makefile |    3 ++-
>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/brcm80211/Makefile b/drivers/staging/brcm80211/Makefile
>> index 05a4103..7a77e7f 100644
>> --- a/drivers/staging/brcm80211/Makefile
>> +++ b/drivers/staging/brcm80211/Makefile
>> @@ -15,8 +15,9 @@
>>   # OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
>>   # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>>
>> -EXTRA_CFLAGS := -DBCMDBG -DWLC_HIGH -DSTA -DWME -DWL11N -DDBAND -DBCMDMA32 -DBCMNVRAMR -Idrivers/staging/brcm80211/sys -Idrivers/staging/brcm80211/phy -Idrivers/staging/brcm80211/util -Idrivers/staging/brcm80211/include -Wall -Wstrict-prototypes -Werror -Wmissing-prototypes
>> +EXTRA_CFLAGS := -DBCMDBG -DWME -DWL11N -DDBAND -DBCMDMA32 -DBCMNVRAMR -Idrivers/staging/brcm80211/sys -Idrivers/staging/brcm80211/phy -Idrivers/staging/brcm80211/util -Idrivers/staging/brcm80211/include -Wall -Wstrict-prototypes -Werror -Wmissing-prototypes
>
> how about 2 patches here, one to break it out into one flag per line so
> we can see what is really happening here, and then one patch to make the
> change you are asking for.
>
>>
>> +USB_CFLAGS := -DWLC_HIGH
>
> Are you sure about this?  Why set this when I don't see anything ever
> using it?
>
> What problem are you trying to fix here.
>
> totally confused,
>
> greg k-h
>

Well, when groveling through the code you can see a bunch of '#ifdef 
WLC_HIGH_ONLY' which I initially assumed was defined because of 
'-DWLC_HIGH' in EXTRA_CFLAGS. This is quite misleading if you don't 
notice 'PCI_CFLAGS := -DWLC_LOW' a bit later in the Makefile (which I 
didn't for quite awhile). Specifying both macros in EXTRA_CFLAGS seems 
unnecessary.

The macro magic happens in brcm80211/sys/wlc_cfg.h:

/* Keep WLC_HIGH_ONLY, WLC_SPLIT for USB extension later on */
#if !defined(WLC_LOW)
#define WLC_HIGH_ONLY
#endif
#if !defined(WLC_LOW)
#define WLC_SPLIT
#endif

What does WLC_LOW and WLC_HIGH mean anyway?

rtg
-- 
Tim Gardner tim.gardner@canonical.com
