Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab2DLLbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 07:31:22 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:38949 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab2DLLbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 07:31:21 -0400
References: <1334052489.2178.9.camel@shrek.rexursive.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <1334052489.2178.9.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v10]: Hibernation: fix the number of pages used for hibernate/thaw buffering
From: Bojan Smojver <bojan@rexursive.com>
Date: Thu, 12 Apr 2012 21:31:16 +1000
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org, Per Olofsson <pelle@debian.org>
Message-ID: <b84d15d8-f35b-4296-927b-86a722541072@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bojan Smojver <bojan@rexursive.com> wrote: 

>-	read_pages = (nr_free_pages() - snapshot_get_image_size()) >> 1;
>+	read_pages = (low_free_pages() - snapshot_get_image_size()) / 2;

Actually, I am pretty sure this part of the patch is wrong. Image can be bigger than the size of non-high memory. So, this calculation may turn up entirely bogus numbers, given we are dealing with unsigned values. Sure, we clamp that a line later, so all is not lost, but still, it needs to be fixed.

Will have a better version for you tomorrow.

-- 
Bojan
