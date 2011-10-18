Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab1JRBs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:48:57 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:60572 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757165Ab1JRBs4 (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 17 Oct 2011 21:48:56 -0400
Subject: Re: [PATCH] acer-wmi: blacklist Thinkpad edge E520
From: joeyli <jlee@suse.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Joey Lee <jlee@novell.com>
In-Reply-To: <4E97A307.20208@canonical.com>
References: <1318488718-4744-1-git-send-email-ike.pan@canonical.com>
	 <1318523759.1913.68.camel@linux-s257.site>  <4E97A307.20208@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 09:48:11 +0800
Message-ID: <1318902491.1913.348.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ike, 

Could you please attached on the "rfkill list" output when press Fn key?
Then we can check the rfkill status change.

And, 
Thinkpad E520 have AMW0 method and I thought acer-wmi query wrong EC
register address so your acer-wireless was always soft-blocked.

Does it possible kindly help me to find out which register on E520 is
mapping to wireless status? Please reference to Carlos's acer_ec.pl
tool:

http://code.google.com/p/aceracpi/wiki/EmbeddedController

Simple use:
        watch -n 1 perl acer_ec.pl regs

Then press your wireless Fn key to monitor which register changed when
you press Fn key:

e.g. the register at row B0 and column 0A is register 0xBA (0x is used
to indicate this is a hexadecimal number).

There maybe have other EC register changing when you press key, please
do a couple of times and make sure you find out the right one.

If we are lucky, we can find out one EC register mapping to your
wireless state.


Thank's
Joey Lee

於 五，2011-10-14 於 10:48 +0800，Ike Panhc 提到：
> Hi Joey,
> 
> Here you are.
> 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/836865/+attachment/2330828/+files/AcpiTables.txt
> 
> 
> On 10/14/2011 12:35 AM, joeyli wrote:
> > Hi Ike, 
> > 
> > 於 四，2011-10-13 於 14:51 +0800，Ike Panhc 提到：
> >> BugLink: http://launchpad.net/bugs/836865
> >> BugLink: http://launchpad.net/bugs/826784
> >>
> >> There are reports say that acer-wmi is loaded on Thinkpad E520 which
> >> cause wireless connection hard blocked and we can not unblock it. It
> >> will be better not to load acer-wmi on this machine.
> >>
> >> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
> >> ---
> >>  drivers/platform/x86/acer-wmi.c |    7 +++++++
> >>  1 files changed, 7 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> >> index af2bb20..dc9a116 100644
> >> --- a/drivers/platform/x86/acer-wmi.c
> >> +++ b/drivers/platform/x86/acer-wmi.c
> >> @@ -325,6 +325,13 @@ static struct dmi_system_id __devinitdata acer_blacklist[] = {
> >>  			DMI_MATCH(DMI_PRODUCT_NAME, "AOA150"),
> >>  		},
> >>  	},
> >> +	{
> >> +		.ident = "Lenovo Thinkpad Edge E520",
> >> +		.matches = {
> >> +			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> >> +			DMI_MATCH(DMI_PRODUCT_NAME, "114320U"),
> >> +		},
> >> +	},
> >>  	{}
> >>  };
> >>  
> > 
> > Could you please share Thinkpad edge E520's acpidump and dmidecode log
> > to me? 
> > Maybe we can capture how does it works with EC register like we support
> > Ideapad S205 in acer-wmi driver.
> > 
> > Add a machine to blacklist is a last resort, I don't want to accept it
> > before we try.
> > 
> > 
> > Thank's a lot!
> > Joey Lee
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


