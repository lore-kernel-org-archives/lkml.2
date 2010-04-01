Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0DAOmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 10:42:06 -0400
Received: from Cpsmtpm-eml106.kpnxchange.com ([195.121.3.10]:56208 "EHLO
	CPSMTPM-EML106.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396Ab0DAOmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 10:42:00 -0400
From: Frans Pop <elendil@planet.nl>
To: Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH] proc: Report file name on detected read_proc overflow
Date: Thu, 1 Apr 2010 16:41:56 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       adobriyan@gmail.com, helight.xu@gmail.com, viro@zeniv.linux.org.uk
References: <4BB49B0E.8070306@siemens.com>
In-reply-To: <4BB49B0E.8070306@siemens.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004011641.58462.elendil@planet.nl>
X-OriginalArrivalTime: 01 Apr 2010 14:41:58.0873 (UTC) FILETIME=[7BB6B490:01CAD1A9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kiszka wrote:
> -                                      "proc_file_read: Apparent buffer overflow!\n");
> +                                      "proc_file_read: Apparent buffer "
> +                                      "overflow reading \"%s\"!\n",
> +                                      file->f_path.dentry->d_name.name);

I think it would be good to keep "overflow" on the first line as that
may be what people will grep the source for. And maybe use single quotes
around the file name. So:

+                                      "proc_file_read: Apparent buffer overflow "
+                                      "reading '%s'!\n",
+                                      file->f_path.dentry->d_name.name);

Cheers,
FJP
