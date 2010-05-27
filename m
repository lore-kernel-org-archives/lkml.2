Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468Ab0E0Efd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 00:35:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48768 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0E0Efc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 00:35:32 -0400
Date: Thu, 27 May 2010 05:35:31 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Erik van der Kouwe <vdkouwe@cs.vu.nl>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Fam Zheng <famcool@gmail.com>
Subject: Re: [PATCH] fs/minix: bugfix, number of indirect block ptrs per
 block depends on block size
Message-ID: <20100527043531.GY31073@ZenIV.linux.org.uk>
References: <4BFCF1EB.20709@cs.vu.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFCF1EB.20709@cs.vu.nl>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 12:03:23PM +0200, Erik van der Kouwe wrote:

> +#define INDIRCOUNT(sb) ((sb)->s_blocksize / 4)

ITYM (1 << ((sb)->s_blocksize_bits - 2))

Give gcc at least a chance to turn the uses of that into shifts...
Applied with such change.
