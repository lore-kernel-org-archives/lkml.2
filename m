Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088Ab0GOSbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:31:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:45119 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934062Ab0GOSbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:31:10 -0400
Message-ID: <4C3F53D1.3090001@austin.ibm.com>
Date: Thu, 15 Jul 2010 13:30:41 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 0/5] v2 De-couple sysfs memory directories from memory section
 size
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches de-couples the idea that there is a single
directory in sysfs for each memory section.  The intent of the
patches is to reduce the number of sysfs directories created to
resolve a boot-time performance issue.  On very large systems
boot time are getting very long (as seen on powerpc hardware)
due to the enormous number of sysfs directories being created.
On a system with 1 TB of memory we create ~63,000 directories.
For even larger systems boot times are being measured in hours.

This set of patches allows for each directory created in sysfs
to cover more than one memory section.  The default behavior for
sysfs directory creation is the same, in that each directory
represents a single memory section.  A new file 'end_phys_index'
in each directory contains the physical_id of the last memory
section covered by the directory so that users can easily
determine the memory section range of a directory.

For version 2 of this patchset the capability to split a
directory has been removed.

Thanks,

Nathan Fontenot
