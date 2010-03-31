Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0CaOzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 10:55:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64233 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab0CaOzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 10:55:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alessio Igor Bogani <abogani@texware.it>
Subject: Re: [PATCH] USB: Remove BKL from remount() function in usbfs
Date: Wed, 31 Mar 2010 15:54:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>
References: <1270044578-4291-1-git-send-email-abogani@texware.it>
In-Reply-To: <1270044578-4291-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201003311654.38020.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/9kgndiXX/z4HyzgozBbRmES5G0AIBV2MFrKO
 MtQghU4d3XMn2OFpuYz0dUyeOYzI5mTBOnHa/3kZpG68qGuwza
 eOhHAyjwsy+o/DNoXAGLQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 March 2010, Alessio Igor Bogani wrote:
> 
> The BKL was used into remount_fs pointed function for serialized access to
> super_block from the others super_operations functions.
> 
> The function update_sb(), invoked by remount(), seems already well serialized
> with &root->d_inode->i_mutex. Moreover don't seems there are others
> super_operations functions in USB core for usbfs that should access to
> super_block in a way which require BKL.

There is a patch from Jan Blunck pending in the bkl-removal tree that pushes
down the BKL into usbfs_fill_super. Can you confirm that this BKL usage does
not interfere with the one you just removed, and that it can go the same way?

	Arnd
