Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab1BMU1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 15:27:01 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38869 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1BMU05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 15:26:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=SFBzz/6NJO/M5oMmZH/ct8VjKJsJ21GTyzC7CsMC7PfZFenpAWHR/JO+IKRZmhG0bt
         WODsQ/orxFFzXikbaxFxKyvNnhvmbU91l4sBnMMPzNdofdemUfGPcVIlPfQ9dNrBXwwr
         vp+E++JIGp1wPEhQn+gXRahQhdEmRbEm/xUNI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sun, 13 Feb 2011 21:26:56 +0100
Message-ID: <AANLkTikQ0Ys-VS2hXcE+rGmGtc7Qxwm7jpL6q+bbC7nt@mail.gmail.com>
Subject: Re: Regression - Xorg start failed
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: hidave.darkstar@gmail.com
Cc: Dave Airlie <airlied@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn, that issue made me really sick yesterday, as I thought the
problem arrived from my updated mesa/ddx built-from-git (I also played
with mesa's new --enable-shared-dricore configure option).

Also, I suspected x11-common package in Debian/unstable [1],
especially BR #612979 [2].

I applied the revert of commit
47970b1b2aa64464bc0a9543e86361a622ae7c03 ("pci: use security_capable()
when checking capablities during config space read") as bisected by
Dave Young. Thanks!

The only way I found was to delete several X releated dot-dirs in
/tmp. In addition the dirs created/required for a KDE-session.
Best is to kill complete /tmp/* /tmp/.* in runlevel-3 and then startx,
that made X work here.

- Sedat -

[1] http://packages.debian.org/changelogs/pool/main/x/xorg/xorg_7.6+3/changelog
[2] http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=612979
