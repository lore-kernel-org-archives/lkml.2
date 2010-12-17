Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0LQNda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:33:30 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39619 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab0LQNd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:33:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bJyLwsHfVAe1gji6dU3gHPgCgm1ncD8pNbXgYTj3ACWGJLxcbGJ+rKY8sCpPLmGZli
         ANMXe4oCrtXUWcJBb28SPJdIiao091+46qj/VlZn35JkFDjFuOsQ8kBf/RxI6rUxfBWO
         qne440LXT7D+JLWb100ZRpOW8M85bZZWCyLA0=
MIME-Version: 1.0
In-Reply-To: <AANLkTinyLQUN6fMwWQDxvPpfRTo-4kHPVsggPSoAGhv-@mail.gmail.com>
References: <AANLkTinyLQUN6fMwWQDxvPpfRTo-4kHPVsggPSoAGhv-@mail.gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 17 Dec 2010 14:33:11 +0100
Message-ID: <AANLkTin=vr14wPJottefmfsgfyYZbfcmchQerq+0oP5J@mail.gmail.com>
Subject: Re: make xconfig broken on 2.6.37-rc2
To: Ameya Palande <2ameya@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/17 Ameya Palande <2ameya@gmail.com>:
> Hi,
>
> When I try to do "make xconfig" on 2.6.37-rc2 it gives me following error:
>
>  HOSTCXX scripts/kconfig/qconf.o
> In file included from scripts/kconfig/qconf.cc:48:
> scripts/kconfig/qconf.moc:13: fatal error: private/qucomextra_p.h: No
> such file or directory
> compilation terminated.
> make[1]: *** [scripts/kconfig/qconf.o] Error 1
> make: *** [xconfig] Error 2
>
> My host is ubuntu 10.10 x86-32 with libqt3 and libqt4 both installed.

hi !
this is due to moc which points by default to /usr/bin/moc-qt3
just make it point to moc-qt4 :
sudo update-alternatives --config moc

then make distclean, make xconfig.

richard
