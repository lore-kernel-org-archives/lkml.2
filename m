Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab0ENJLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 05:11:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33692 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab0ENJLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 05:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:x-accept-language:user-agent;
        b=TZWMpgiFs/b3izApKBKFugvyo+zy2IlLAmBDPS9N7InNxfEiSD556oVroxIVyyZO3M
         tykNpj2DVxcfqP7KTJFhW3W+nxl8bZzmom4W1GIWvoMYZ5EhCD/ORKJetSNv9zTbxDhR
         lwE1+2t8THYF8moMNTtAI2G8jcwyrP9BVxNH0=
Date: Fri, 14 May 2010 11:11:37 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viriketo@gmail.com>
To: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viriketo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: fds jumping between processes
Message-ID: <20100514091135.GD8773@vicerveza.homeunix.net>
References: <20100514090903.GC8773@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100514090903.GC8773@vicerveza.homeunix.net>
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bah, forget it! firefox problem. Sorry for the noise.

On Fri, May 14, 2010 at 11:09:03AM +0200, Lluís Batlle i Rossell wrote:
> Hello,
> here is quite an open bug report... I could not reproduce this again, but it
> involves the fds opened of a killed process being passed to another process, or
> something like this.
> 
> I'm using vanilla 2.6.33.3 in x86_64.
> I was using skype, talking through it using alsa, and trying the
> 'share desktop' feature, it died. Starting it again, it could not open the alsa
> device. Using fuser:
> 
> ...:/dev/snd]$ fuser *
> controlC0:           32341
> pcmC0D0p:            32341
> timer:               32341
> 
> Which that was:
> $ ps ax | grep 323
> 32341 ?        S      0:01 /home/xxx/.nix-profile/bin/xpdf /tmp/xxx.pdf
> 
> So, after skype (using alsa) died, the xpdf process took the soundcard fds
> skype had. It does not make much sense xpdf to use sound... so I guess something
> worth looking happened.
> 
> I don't have more details. Killing xpdf made the new skype open the alsa device
> properly.
> 
> Sorry for not having analised the situation better. Now I cannot reproduce it
> anymore. Maybe this will make someone knowing say "ah, let me look if ...". I
> just thought if this is a bug in the kernel, it can involve security problems.
> 
> Thank you,
> Lluís.
