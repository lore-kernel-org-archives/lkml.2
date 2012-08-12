Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464Ab2HLGoW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 02:44:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab2HLGoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 02:44:20 -0400
Date: Sun, 12 Aug 2012 15:44:16 +0900 (JST)
Message-Id: <20120812.154416.1611788053634506933.yamato@redhat.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/15] net: proc entry showing inodes on sockfs and
 their types
From: Masatake YAMATO <yamato@redhat.com>
In-Reply-To: <20120811.210434.961670950702666620.davem@davemloft.net>
References: <1344715638-22997-1-git-send-email-yamato@redhat.com>
	<20120811.210434.961670950702666620.davem@davemloft.net>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Sorry, you cannot do this.
> 
> You are adding a new lock and insert into a global list for
> pretty much every socket created, that will destroy performance.

I think there are no serious performance penalty in generally use.
Most frequently used types of sockets like tcp, udp, and unix are not
stored to the global list and don't touch the new lock at all.
Please, look at has_own_proc_entry in struct proto.

> You also cannnot add new fields to socket listing procfs files,
> it will break existing application which depend upon the existing
> exact layout of those fields.

Is there any strcut which can be extended? 
Extending struct sock is o.k.?

Masatake YAMATO
