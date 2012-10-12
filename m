Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab2JLTVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 15:21:42 -0400
Received: from mga12.intel.com ([143.182.124.36]:56204 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751274Ab2JLTVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 15:21:40 -0400
Message-ID: <1350069693.15966.591.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH 2/5] efivarfs: efivarfs_create() ensure we drop our
 reference on inode on error
From: Matt Fleming <matt.fleming@intel.com>
To: Khalid Aziz <khalid@gonehiking.org>
Cc: Andy Whitcroft <apw@canonical.com>, Matthew Garrett <mjg@redhat.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 12 Oct 2012 20:21:33 +0100
In-Reply-To: <1350068629.7065.58.camel@rhapsody>
References: <1349416496.810727.310563927016.1.gpush@pecola>
	 <1349951541-20498-1-git-send-email-apw@canonical.com>
	 <1349951541-20498-3-git-send-email-apw@canonical.com>
	 <1350068629.7065.58.camel@rhapsody>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 13:03 -0600, Khalid Aziz wrote:
> This does not read right. If kzalloc() fails, var will be a NULL
> pointer. This code will set err to -ENOMEM and jump to out: where since
> err is non-zero, this code will call kfree(Var) but var is a NULL
> pointer at this point. Now kfree() does check for NULL pointer and this
> will not cause any serious problems but why call kfree for a NULL
> pointer?

This is a common idiom used throughout the kernel to simply error paths.
As you noted, calling kfree(NULL) is harmless and there's certainly no
need to worry about the overhead of calling kfree() without doing any
freeing since the error path is also the slow path.

