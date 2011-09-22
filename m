Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1IVVXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:23:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:50910 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab1IVVXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:23:15 -0400
Subject: Re: [PATCH 0/3] Replace kmalloc with vmalloc in seq_files
From: Peter Zijlstra <peterz@infradead.org>
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Date: Thu, 22 Sep 2011 23:22:49 +0200
In-Reply-To: <1316725029-22737-1-git-send-email-ccross@android.com>
References: <1316725029-22737-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316726569.31040.37.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-22 at 13:57 -0700, Colin Cross wrote:
> 
> seq_files are often used for debugging data.  When the system is under
> memory pressure, and dumping debugging data starts trying to allocate
> large physically contiguous buffers, it often makes the problem
> worse. 

Shouldn't you be using ->next instead of dumping everything in a single
seqop? That way it can return partial buffers and keep state etc.
