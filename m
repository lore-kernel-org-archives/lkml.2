Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1D3MPQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 08:15:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:55747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab1D3MPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 08:15:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Kara <jack@suse.cz>
Subject: Re: Allow setting of number of raw devices as a module parameter
Date: Sat, 30 Apr 2011 14:15:02 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1304029469-19672-1-git-send-email-jack@suse.cz>
In-Reply-To: <1304029469-19672-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104301415.02349.arnd@arndb.de>
X-Provags-ID: V02:K0:slOIwp61O6FPTh2BkeYR6hG6FanetguLMhublUV7JuB
 ramMKdw/+Mxrd4cAMt/rRY376YBM5Wi5gQGfs3jN8t9tGxW4bJ
 aXfjsOe1APseute8Mn2HZU8Vzs/+r9ZuZ+/MhHaEpoF1aZa5i8
 ONKG+o24J6MSBlx4LeJcmcwcXITsiiRYNf4opi1yU8Ru854tb1
 nmoq/kO+V3DWZGJjMm+SA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 April 2011 00:24:29 Jan Kara wrote:
> Allow setting of maximal number of raw devices as a module parameter. This
> requires changing of static array into a vmalloced one (the array is going to
> be too large for kmalloc).
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

Why don't you get rid of the global raw_devices array instead?

I suppose if you embed the struct cdev in raw_device_data and
register it during RAW_SETBIND separately for each raw device
instead of globally at raw_init time, you can support any number
of devices while making the code smaller and simpler. I suppose
you can even remove the raw_mutex then.

	Arnd
