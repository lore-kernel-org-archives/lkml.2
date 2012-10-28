Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab2J1T26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:28:58 -0400
Received: from nm17.access.bullet.mail.mud.yahoo.com ([66.94.237.218]:21290
	"EHLO nm17.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754764Ab2J1T2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:28:54 -0400
X-Yahoo-Newman-Id: 390211.45733.bm@smtp110.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: QB09qTwVM1nVfCciiGzFGWpjKm5jwpy7VfnOVrBWcRUJ4il
 p5ovTag8pejtYrWarUrDVSwAY3Oo_v4oJq5kvfGeUH9EyyjSA6FUQWBxH.4t
 RlSkIs7xUC6qiEwEcByJXlHgo72jH.6mojl_R9p2u6elZ8MSObkRAtYIpVwX
 f9O10LmxjHxvZrtZz4PQDtTha2x_VFhwZ64qBiZ.EuVLZFqOaJ341dZ9k59p
 ypGuU0VBNHwT3pldjgCcmUbXY8pCH4d0ovZjLDcps5lGpwHYLKkEGw_Xsv_2
 H_2q2vUG4U3_C56dPY4YhQEimswp9OmIaONp8MGZ9p2pS_fqKbInE6fFmOLq
 9V9CmX1CZ_UWwv4bq9.mzvwOGBTc2yueGR_0HOqhBfzk9BT1L1Mi6ZRzCM3v
 r87oez8R_3ibbItcCGqrB9LWbuGj7YxULp35kV9mEjrldqOOBvX6E_gkzr1W
 x_iWDncNBItV5TGoPbtn0Mavsgg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <508D8629.4040208@att.net>
Date: Sun, 28 Oct 2012 14:23:21 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 04/10] bug.h: directly include linux/compiler.h
References: <1351096132-12244-1-git-send-email-daniel.santos@pobox.com> <1351096441-12388-4-git-send-email-daniel.santos@pobox.com> <20121024195520.GD17945@liondog.tnic>
In-Reply-To: <20121024195520.GD17945@liondog.tnic>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2012 02:55 PM, Borislav Petkov wrote:
> On Wed, Oct 24, 2012 at 11:33:55AM -0500, danielfsantos@att.net wrote:
>> Currently, we are only including asm/bug.h and then expecting that
>> linux/compiler.h will eventually be included to define __linktime_error
>> (used in BUILD_BUG_ON). This patch includes it directly for clarity and
>> to avoid the possibility of changes in <arch>/*/include/asm/bug.h being
>> changed or not including linux/compiler.h for some reason. (Later
>> patches will in this set use more macros defined in compiler*.h.)
>>
>> Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
>> ---
>>  include/linux/bug.h |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/bug.h b/include/linux/bug.h
>> index aaac4bb..4bd74d8 100644
>> --- a/include/linux/bug.h
>> +++ b/include/linux/bug.h
>> @@ -2,6 +2,7 @@
>>  #define _LINUX_BUG_H
>>  
>>  #include <asm/bug.h>
>> +#include <linux/compiler.h>
>>  
>>  enum bug_trap_type {
>>  	BUG_TRAP_TYPE_NONE = 0,
>> -- 
>> 1.7.3.4
> Why is this a separate patch and why not add that single line in 6/10
> where you define BUILD_BUG_ON?
>
> Thanks.
Sorry about that.  I think this was originally in another patch with
something else that I moved to another patch set and it ended up by its
self.  I'll squash it and resubmit.

