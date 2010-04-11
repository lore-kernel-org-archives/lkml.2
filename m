Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab0DKQrJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 12:47:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64487 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0DKQrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 12:47:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=tg2vHm3UyuM/ISHmF17d5kLgu5IdqZHnBImln670BaQCP30AwUq3t4ILO/EC4PCLhW
         VOdr6j0p5LPRdS91pOPIRLGNnkXyoLcXQquLJJNB5HJK/iNpIOfmA/Tbt60uhU/Nfnsp
         uF5r45IW/srIZ6+IY5GDRGrgvn23AsaL8rE6g=
Message-ID: <4bc1fd09.9615f10a.46f6.ffffab58@mx.google.com>
Date: Sun, 11 Apr 2010 09:47:05 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Re: [REGRESSION] Lockup inside of stop_machine() during modprobe aes
	(was Re: Another AR5008 hang)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ath9k@venema.h4ckr.net
In-Reply-To: <4bbb7896.48c3f10a.30b9.365b@mx.google.com>
References: <4bb0e2da.04c2f10a.32b2.11ae@mx.google.com>
	<1269928986.3927.5.camel@jlt3.sipsolutions.net>
	<4bb1f940.47c2f10a.3469.609b@mx.google.com>
	<4bb235fb.0baa660a.5b56.ffffa9c2@mx.google.com>
	<4bbb7896.48c3f10a.30b9.365b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Apr 2010 11:08:22 -0700 (PDT), Ben Gamari <bgamari.foss@gmail.com> wrote:
> Hey all,
> 
> I just built 2.6.34-rc3 with the appropriate fixes for the ACPI thermal lockdep
> issues and have attached the dmesg output of the crash below. It appears that
> modprobe is freezing with a few locks held while inserting aes.ko. In
> particular, it seems that the kernel is deadlocking inside of stop_machine()
> while flushing workqueues.
> 
I can confirm that modprobing aes explicitly also results in the stop_machine()
deadlock, so this doesn't appear to be an interaction with ath9k or the
mac80211 subsystem.

Furthermore, if I disable CONFIG_CRYPTO_AES_X86_64 (I'm on a Core Duo
platform), aes loads as expected and things work as they should. 

Any ideas? I'm rather disturbed that this regression has still not had a single
reply while -rc4 is so near.

- Ben
