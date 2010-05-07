Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab0EGNiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 09:38:24 -0400
Received: from exhub016-3.exch016.msoutlookonline.net ([207.5.72.226]:33025
	"EHLO EXHUB016-3.exch016.msoutlookonline.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753008Ab0EGNiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 09:38:22 -0400
Message-ID: <4BE417CB.7000806@cfl.rr.com>
Date: Fri, 7 May 2010 09:38:19 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
Subject: unified page and buffer cache? (was: readahead on directories)
References: <4BCC7C05.8000803@cfl.rr.com>
In-Reply-To: <4BCC7C05.8000803@cfl.rr.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought that the buffer and page caches were unified long ago, but
last night I modified ureadahead to call readahead() directly on the
block device for all physical extents involved rather than open() each
file and readahead() on that.  It read all of the related blocks into
the buffer cache nice and fast, which was then ignored and the data was
read again when accessed normally during boot.

So it seems that the buffer cache and page cache are still separate, and
normal files only use the page cache, and directories only use the
buffer cache, which is why readahead() fails when called on a directory.

Can anyone confirm that my disappointed understanding is correct?  I
started experimenting with a workaround where I readahead directories
via the block device, and normal files the normal way.  This seems to do
the trick, but is sub optimal since you have to read in two passes,
picking up the directories on the first pass, then going back for the files.
