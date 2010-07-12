Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0GLP1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:27:24 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:35668 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab0GLP1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:27:23 -0400
Message-ID: <4C3B3446.5090302@austin.ibm.com>
Date: Mon, 12 Jul 2010 10:27:02 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linuxppc-dev@ozlabs.org
Subject: [PATCH 0/7] De-couple sysfs memory directories from memory sections
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
represents a single memory section.  This update also adds to
new files to each sysfs memory directory.  The file 'end_phys_index'
contains the physical id of the last memory section covered by
the directory.  The file 'split' allows for splitting the 
directory in two, with each new directory covering half as many
memory sections as the previous directory.

Thanks,

Nathan Fontenot
