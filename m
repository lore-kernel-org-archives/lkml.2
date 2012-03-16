Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab2CPVZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:25:55 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:56616 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab2CPVZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:25:54 -0400
Message-ID: <4F63AFD5.3010607@shealevy.com>
Date: Fri, 16 Mar 2012 17:25:41 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: matt.fleming@intel.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Proposal: EFI boot stub configuration file
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

In some EFI boot environments (e.g. booting from an external medium or 
non-standard systems where tools like efibootmgr don't work), it is 
currently impossible to pass the right arguments to the kernel unless an 
EFI shell is launched. To ameliorate this, I propose that if 
image->load_options_size is 0 (indicating no arguments were passed) AND 
image->parent_handle is NULL (indicating that the image was loaded 
automatically by the firmware), then the kernel looks for a file in some 
fixed, possibly configurable place (e.g. \efi\linux\params), sets 
image->load_options_size to its size, and sets image->load_options to 
its contents. On any error whatsoever (finding the file, reading it, 
getting its size, whatever), any allocated memory would be freed and 
load_options_size would be set back to 0. Since the arguments are 
already converted to ASCII and parsed during the boot process, the file 
would be expected to be in UCS-2 format and no validation would be done 
in the configuration loading code. I'll write something up over the next 
week or so and submit it as an RFC patch series, but I thought I'd post 
this here first in case anyone has immediate feedback based on this 
description.

Cheers,
Shea Levy
