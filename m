Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2JOX1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 19:27:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49280 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2JOX1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 19:27:07 -0400
Date: Tue, 16 Oct 2012 00:27:05 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bisected regression in Linux 3.7.0-rc1, hang on login caused by
 replace_fd()
Message-ID: <20121015232705.GM2616@ZenIV.linux.org.uk>
References: <20121015171437.32e9a4ac@mj>
 <20121015215127.GK2616@ZenIV.linux.org.uk>
 <20121015191105.2dac4cac@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015191105.2dac4cac@mj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	I think I understand what's going on there.  Add fput(files[0])
after that replace_fd(); we have a leak and while that's not the right
way to fix it, that'd verify if anything else is going on there.
