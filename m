Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0FMWNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 18:13:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65106 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0FMWNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 18:13:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=hQqCthZJExzFx/FnB99B0RASAadQbpPgF4AAaS+RjbTDRcJ2rFWNUn7348heGK5z/l
         lSemsUMXnYzjaHKAVWrIk5cN0RzqOk8KAbwnSQbZ/dsmLAAbWLPfFP0V2r4TTicS7dMi
         2ym/xdM2jGIOTggJYt6R1y1sMwOaQ+Ver8MfE=
From: Gene Heskett <gene.heskett@gmail.com>
Organization: Organization? very little
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Noticeable slow-down in 2.6.35-rc3
Date: Sun, 13 Jun 2010 18:13:04 -0400
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
References: <AANLkTimDUf0N6b5PBy2wTGeAWEIY-lUvQPHQ7D7Gyrq4@mail.gmail.com> <201006132158.09216.chris2553@googlemail.com> <201006132211.03744.chris2553@googlemail.com>
In-Reply-To: <201006132211.03744.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201006131813.04096.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 June 2010, Chris Clayton wrote:
>On Sunday 13 June 2010 21:58:09 Chris Clayton wrote:
>> On Sunday 13 June 2010 21:35:25 François Valenduc wrote:
>> > Le 13/06/10 22:15, Chris Clayton a écrit :
>>
>> <snip>
>>
>> > > I've bisected it and arrived at:
>> > >
>> > > 597a264b1a9c7e36d1728f677c66c5c1f7e3b837 is the first bad commit
>> > > commit 597a264b1a9c7e36d1728f677c66c5c1f7e3b837
>> > > Author: John Fastabend <john.r.fastabend@intel.com>
>> > > Date:   Thu Jun 3 09:30:11 2010 +0000
>>
>> <snip>
>>
>> > This commit also makes nfsd hangs at startup on my computer (see
>> > https://bugzilla.kernel.org/show_bug.cgi?id=16195). This problem
>> > doesn't occur if it's reverted.
>>
>> I've just found John Fastabend's easy and fast fix
>> (http://marc.info/?l=linux-kernel&m=127646140827821) and am about to
>> apply it and test the new kernel. back soon!
>
>Yes, that's fixed the problem I reported.
>
Unfortunately, this patch will not apply to my src tree for 2.6.35-rc3, 
even after I fixed the unwanted line wrap in the first active line.

I get:

[root@coyote linux-2.6.35-rc3]# patch -p1 <../2.6.35-rc3-test.patch
patching file net/core/skbuff.c
Hunk #1 FAILED at 532.
1 out of 1 hunk FAILED -- saving rejects to file net/core/skbuff.c.rej

Did my grabbing it with swiftfox damage it even further?
------------------------------------------------------------------
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9f07e74..bcf2fa3 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -532,6 +532,7 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
  	new-&gt;ip_summed		= old-&gt;ip_summed;
  	skb_copy_queue_mapping(new, old);
  	new-&gt;priority		= old-&gt;priority;
+	new-&gt;deliver_no_wcard	= old-&gt;deliver_no_wcard;
  #if defined(CONFIG_IP_VS) || defined(CONFIG_IP_VS_MODULE)
  	new-&gt;ipvs_property	= old-&gt;ipvs_property;
  #endif
---------------------------------------------------------------

That line 532 is not at line 532 in my src tree, its at line 516 here.

I have seen this sort of thing before when using bz2 src files, but this is
all from gzipped stuffs.  ???

Thanks for any hints.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Depends on how you define "always".  :-)
             -- Larry Wall in <199710211647.JAA17957@wall.org>
