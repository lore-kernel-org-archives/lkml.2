Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750903Ab2HLEEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 00:04:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57749 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2HLEEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 00:04:37 -0400
Date: Sat, 11 Aug 2012 21:04:34 -0700 (PDT)
Message-Id: <20120811.210434.961670950702666620.davem@davemloft.net>
To: yamato@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/15] net: proc entry showing inodes on sockfs and
 their types
From: David Miller <davem@davemloft.net>
In-Reply-To: <1344715638-22997-1-git-send-email-yamato@redhat.com>
References: <1344715638-22997-1-git-send-email-yamato@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry, you cannot do this.

You are adding a new lock and insert into a global list for
pretty much every socket created, that will destroy performance.

You also cannnot add new fields to socket listing procfs files,
it will break existing application which depend upon the existing
exact layout of those fields.
