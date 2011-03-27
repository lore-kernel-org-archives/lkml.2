Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1C0LTF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 07:19:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64632 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab1C0LTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 07:19:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Date: Sun, 27 Mar 2011 13:18:58 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        gregkh@suse.de
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <201103262151.47061.arnd@arndb.de> <AANLkTikyGwaUYdRbqiKiMWmyRbajbb22C7AgRHhz=wJu@mail.gmail.com>
In-Reply-To: <AANLkTikyGwaUYdRbqiKiMWmyRbajbb22C7AgRHhz=wJu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103271318.58127.arnd@arndb.de>
X-Provags-ID: V02:K0:H+19PnXpj81XQofU4QCapr0jOG60qKCK7clzhcAKMnS
 ycpjjg1j1BlePyHfZJ7ro0zPCestrEf0vGQPiUPmZ+0jOR8nJN
 5hcpuBmNuGB6mpLDi/dWJWKx1OIzY8loQhi1yhhO6nrP6FIaO2
 9NmbJmO4vaLao1v4l8o4e0HAMKClMQ97PG9P8FOsoqB7dbjc5R
 3IK54fC7Jjo8LNSfE0RCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 March 2011 05:52:04 Mike Frysinger wrote:
> On Sat, Mar 26, 2011 at 16:51, Arnd Bergmann wrote:
> > Fine with me, if you can name at least one possible use for a flag.
> 
> i tend to assume that i cant think of all cases when i first write up
> something, so better to leave a hole for the future ;)

This makes sense for real syscalls, where adding a new one is a lot
of work. For an ioctl, adding a flag is almost exactly the same
amount of work as adding another ioctl command, but it adds complexity
for the first one, e.g. you need to decide how to handle unknown
flags passed to the kernel (ignore, bail out, or a combination).

It also makes correctly using the ioctl harder and adds a tiny
amount of overhead for parsing the flags and copying the addititional
word. Adding a flags word "just in case" is therfore counterproductive.

	Arnd
