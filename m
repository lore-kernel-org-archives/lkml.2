Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab0K0TWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 14:22:52 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44451 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab0K0TWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 14:22:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=x+RVoMSwzfCELdeEVE2mGfsDQly2W4UgLFgKsl4fqd7Z3tn3+8YBK2H8AMPqASuwkL
         GaCrbsNqWk6vGlAyzYPgFhl6EqKLis/SMGoGhbKPPILiDXdyE0s+BaifY2P+ekkNqaa+
         UyGiZgVebdjWnn81Wy7001tkhW6/Fsv+buagk=
From: Jason Vas Dias <jason.vas.dias@gmail.com>
Reply-To: jason.vas.dias@gmail.com
To: Ben Gamari <bgamari@gmail.com>
Subject: Re: per-chroot clock module ?
Date: Sat, 27 Nov 2010 19:22:45 +0000
User-Agent: KMail/1.12.4 (Linux/2.6.34-jvd; KDE/4.3.4; x86_64; svn-1073138; 2010-01-11)
Cc: linux-kernel@vger.kernel.org
References: <201011271821.35039.jason.vas.dias@gmail.com> <874ob2r3w0.fsf@gmail.com>
In-Reply-To: <874ob2r3w0.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011271922.45611.jason.vas.dias@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 November 2010 18:57:19 Ben Gamari wrote:
> On Sat, 27 Nov 2010 18:21:34 +0000, Jason Vas Dias <jason.vas.dias@gmail.com> wrote:
> > Greetings -
> > 
> > Sorry in advance if this is a stupid idea, but -
> > 
> > I'd really like to be able to set a distinct "clock" for a specific chroot environment, 
> > such that the super-user could call :
> > [snip]
> 
> It certainly doesn't sound like a particularly good idea to me. This
> would add great complexity to the kernel while having very few
> users. Perhaps there's something I haven't considered but I can't think
> of any good applications for this sort of functionality. Do you have
> something in particular in mind?

I'm not sure that it need be that complex -
  o kernel knows chroot() has succeeded so adds the inode of that directory to a "inode <-> clock_offset" mapping
     initialized to 0.
  o this mapping could perhaps also be used to provide other future per-chroot specific features - as for instance 
     a per-chroot  list of extra acceptable binary executable formats ?
  o clock_gettime() and gettimeofday() and time() and clock_settime() are modified to see if the root device inode 
     number has a non-zero real-time clock offset, and, if so, apply it to the real-time clock returned or in the case
     of clock_settime(), set the associated offset to a non-zero value.

RE: why ?
This would allow one to very easily support websites for totally different timezones , where offsets need not be
restricted to legal timezone offsets but could encompass years - also nice if you want to run applications whose
license key has expired .  Also very easy to support multiple instances of cron(1) running in different timezones.
In any case, the module would ensure that the time the kernel sees internally for all processes is the actual real-time
clock value; only processes which have their root directory in one of the special chroot directories would get
a different gettimeofday() or clock_gettime() value .
  
> 
> It seems like what you want here is simple virtualization. Have you
> considered KVM? The closest thing to your request currently upstream is
> containers, although I'm unsure of whether a container can be created
> with an independent clock. Might be something to look into.
> 

To me, using virtualization to solve this problem is like using a sledgehammer to crack a nut,
particularly if the optimal performance of the processes running in such chroot environments
is of paramount importance. 

> Cheers,
> 
> - Ben
> 

Thanks for your comments,  but I think it is still a good idea and I'm investigating now - 
it doesn't seem to need to be too complex to me.

All the best,
Jason.
