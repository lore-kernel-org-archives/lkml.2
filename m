Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0JZDri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 23:47:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58294 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab0JZDrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 23:47:36 -0400
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=Ot7i4hbfXkcA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=Br9LfDWDAAAA:8 a=9aeh_F-pufwx7IlHrzYA:9 a=sek0bc_gCt84zss4LlIA:7 a=xuakQrfcutP-K-j-c4rJHytQcfIA:4 a=PUjeQqilurYA:10 a=hXFNqW0bEOwA:10 a=mcLO0ii1alv6ts35:21 a=BdH3JmM5R4-CTDr1:21 a=65CK5qVxLDD1a2qX:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: bug in streamline_config.pl
From: Steven Rostedt <rostedt@goodmis.org>
To: member graysky <graysky@archlinux.us>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTimgsbFWz34m52+=bgYiccCMc3acSE40qDhCM2tx@mail.gmail.com>
References: <AANLkTikHTu=MsoYu=PPxAh7t6oGPKnp=FybNMPXkMSx3@mail.gmail.com>
	 <1288013006.18238.0.camel@gandalf.stny.rr.com>
	 <AANLkTikdVu4k21K0G9C8vZ54=yGiBFKpGxdPaZM9cEPv@mail.gmail.com>
	 <1288041261.18238.7.camel@gandalf.stny.rr.com>
	 <AANLkTimgsbFWz34m52+=bgYiccCMc3acSE40qDhCM2tx@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 25 Oct 2010 23:47:34 -0400
Message-ID: <1288064854.18238.66.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 17:29 -0400, member graysky wrote:
> Glad to Steve.
> 
> Just did it to 2.26.36.  I repeated the build that is detailed in that
> archlinux thread.  Again, there are TONS of modules in the thing when
> I only had 93 probed.  I know some are dependencies, but if I contrast
> that number to the number that got built by calling your script
> manually, it is far less. 
> 
> Glad to provide details upon request, but everything is in that
> thread:
> 
> https://bbs.archlinux.org/viewtopic.php?pid=830221
> 
Yes, I've seen the thread, and have even commented on it a while back.
But I'm not much for web site comments for debugging. I prefer LKML
email. ;-)

I've read it and I'm still not sure what you deem is broken. By running
the script directly, you will not process any Kconfigs. This means that
dependencies are not processed. This was what the original
streamline_config.pl did, until I received bug reports about it
producing non booting kernels.

Also, make localmodconfig will search for a .config to use if one is not
present. You do not need to copy over one.

Could you send me the output of lsmod, and the .config you started with,
and I can tell you why it selected what it did.

BTW, you can use lsmods from various boxes by doing:

 (on another box) $ lsmod > mymod
                  $ scp mymod myhost:/tmp/


 (on your myhost) $ make LSMOD=/tmp/mymod localmodconfig

and it will use the modules in the file mymod over the local lsmod.


-- Steve



