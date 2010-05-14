Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab0ENJJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 05:09:14 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:49814 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab0ENJJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 05:09:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:content-transfer-encoding:x-accept-language
         :user-agent;
        b=pqZNG8nvVubrcYmfSbjXsjYedASTzVS3UAp/1Pzo7bYbvxl0VHmL5+vG4nhh+GktLH
         NY1g0IuDwz0SyjfDBTSsWxF3MMCzMkYgeh0hjtyrTYF2hnnpn0jIuR4nxF5XQj/Ty4Ge
         3tQ4DjXtvr4zRHRs60K0ajFFcT6FjAE/KkwMQ=
Date: Fri, 14 May 2010 11:09:05 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viriketo@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: fds jumping between processes
Message-ID: <20100514090903.GC8773@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Accept-Language: ca, es, eo, ru, en, jbo, tokipona
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
here is quite an open bug report... I could not reproduce this again, but it
involves the fds opened of a killed process being passed to another process, or
something like this.

I'm using vanilla 2.6.33.3 in x86_64.
I was using skype, talking through it using alsa, and trying the
'share desktop' feature, it died. Starting it again, it could not open the alsa
device. Using fuser:

...:/dev/snd]$ fuser *
controlC0:           32341
pcmC0D0p:            32341
timer:               32341

Which that was:
$ ps ax | grep 323
32341 ?        S      0:01 /home/xxx/.nix-profile/bin/xpdf /tmp/xxx.pdf

So, after skype (using alsa) died, the xpdf process took the soundcard fds
skype had. It does not make much sense xpdf to use sound... so I guess something
worth looking happened.

I don't have more details. Killing xpdf made the new skype open the alsa device
properly.

Sorry for not having analised the situation better. Now I cannot reproduce it
anymore. Maybe this will make someone knowing say "ah, let me look if ...". I
just thought if this is a bug in the kernel, it can involve security problems.

Thank you,
Lluís.
