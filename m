Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031440Ab2CPV3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:29:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41478 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031321Ab2CPV3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:29:04 -0400
Message-ID: <4F63B093.9020104@zytor.com>
Date: Fri, 16 Mar 2012 14:28:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Shea Levy <shea@shealevy.com>
CC: linux-kernel@vger.kernel.org, matt.fleming@intel.com
Subject: Re: Proposal: EFI boot stub configuration file
References: <4F63AFD5.3010607@shealevy.com>
In-Reply-To: <4F63AFD5.3010607@shealevy.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 02:25 PM, Shea Levy wrote:
> Hello,
> 
> In some EFI boot environments (e.g. booting from an external medium or
> non-standard systems where tools like efibootmgr don't work), it is
> currently impossible to pass the right arguments to the kernel unless an
> EFI shell is launched. To ameliorate this, I propose that if
> image->load_options_size is 0 (indicating no arguments were passed) AND
> image->parent_handle is NULL (indicating that the image was loaded
> automatically by the firmware), then the kernel looks for a file in some
> fixed, possibly configurable place (e.g. \efi\linux\params), sets
> image->load_options_size to its size, and sets image->load_options to
> its contents. On any error whatsoever (finding the file, reading it,
> getting its size, whatever), any allocated memory would be freed and
> load_options_size would be set back to 0. Since the arguments are
> already converted to ASCII and parsed during the boot process, the file
> would be expected to be in UCS-2 format and no validation would be done
> in the configuration loading code. I'll write something up over the next
> week or so and submit it as an RFC patch series, but I thought I'd post
> this here first in case anyone has immediate feedback based on this
> description.
> 

A file in UCS-2 seems messed up.

Otherwise, seems like a reasonable idea, with a major caveat... since
the whole point of this is to do something when it isn't possible to set
NVRAM variables, it would make most sense to me if the configuration
file could be founin a specific location relative to the kernel image
itself.

	-hpa

