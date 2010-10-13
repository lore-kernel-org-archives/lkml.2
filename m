Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070Ab0JMPm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 11:42:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61136 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab0JMPm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:42:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Valdis.Kletnieks@vt.edu
Subject: Re: Stupid lockdep question...
Date: Wed, 13 Oct 2010 17:43:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <38780.1286984249@localhost>
In-Reply-To: <38780.1286984249@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010131743.00275.arnd@arndb.de>
X-Provags-ID: V02:K0:Thp6+v52M1Tejb4dbUkBYVEszSQzol3yHSaU/1teRWk
 20LnQkRsrxOj07/ewQISFSZRezuFsueK6v2fAdIlricqwcEUN9
 xfhKr/lOQbP/YU8FdRIKShtgfiP58cUYAMuwmQ9QCxpeiHiW/J
 AMwkF5RfkGNSSKXRXNW1gW6yrDu3qc3mGqhwvDnKuv6PBUp5ZG
 c2B6b7c/OM0KlRXR2DISA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 October 2010, Valdis.Kletnieks@vt.edu wrote:
>   I have a 3rd-party module, that throws this whinge:
> 
> [   65.831296] INFO: trying to register non-static key.
> [   65.831301] the code is fine but needs lockdep annotation.
> [   65.831303] turning off the locking correctness validator.
> 
> I've identified that it's a call to down(*foo) where foo points to a kmalloc'ed
> block of memory that's memset() to all-zeros. What's the initializer/annotation
> I need to add to my code?
> 

It would be easier if you posted a link to the source, but the best
answer is problably:

- replace the semaphore with a regular mutex,
- use mutex_init to initialize it after the allocation.

	Arnd
