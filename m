Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1GPPdz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 11:33:55 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42160 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755380Ab1GPPdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 11:33:52 -0400
Date: Sat, 16 Jul 2011 17:33:41 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the jdelvare-hwmon
 tree
Message-ID: <20110716173341.06f95d72@endymion.delvare>
In-Reply-To: <20110716170601.0ffa821a61bbcd8cf6c3a096@canb.auug.org.au>
References: <20110716170601.0ffa821a61bbcd8cf6c3a096@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sat, 16 Jul 2011 17:06:01 +1000, Stephen Rothwell wrote:
> After merging the jdelvare-hwmon tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/hwmon/max1111.c: In function 'max1111_remove':
> drivers/hwmon/max1111.c:213:2: error: incompatible type for argument 1 of 'mutex_destroy'
> include/linux/mutex-debug.h:21:13: note: expected 'struct mutex *' but argument is of type 'struct mutex'
> 
> Caused by commit d2fbca2996a8 ("hwmon: (max1111) Fix race condition
> causing NULL pointer exception").  Missing '&'?

Oh, right, good catch. It went unnoticed so far because mutex_destroy
resolves to nothing unless CONFIG_DEBUG_MUTEXES=y. I plan to submit a
patch turning the empty implementation of mutex_destroy to an inline
function, so that this kind of problem gets caught earlier.

> I have used the jdelvare-hwmon tree from next-20110707 for today.

Problem is fixed now, thanks.

-- 
Jean Delvare
