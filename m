Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0FCHId (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:08:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34361 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab0FCHI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:08:29 -0400
Date: Thu, 3 Jun 2010 03:08:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Jan Blunck <jblunck@suse.de>
Subject: Re: [RFC 4/5] BKL: use no BKL in llseek
Message-ID: <20100603070827.GB12123@infradead.org>
References: <1275523999-27462-1-git-send-email-arnd@arndb.de> <1275523999-27462-5-git-send-email-arnd@arndb.de> <20100603003826.GD5164@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603003826.GD5164@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 02:38:27AM +0200, Frederic Weisbecker wrote:
> This should be simply dropped and we can make use of generic_file_llseek
> instead, as the fallback llseek.

generic_file_llseek contains the sb->s_maxbytes check, so it needs at
least a careful audit first.  But as mentioned about a dozend times
before it's an just as bad default.  The correct default to go ahead
it to not allow seeking and pread/pwrite unless a ->lseek method is set,
and I've already explained a step by step guide how to get there in
easily bisectable steps.  And the addition of nonseekable_open/no_llseek
by you BKL guys already got us much closer to this, so please follow up
on that work and do it properly.

