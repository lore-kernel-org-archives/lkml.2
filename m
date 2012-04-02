Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab2DBTLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 15:11:08 -0400
Received: from oyp.chewa.net ([91.121.6.101]:58904 "EHLO oyp.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751742Ab2DBTLG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 15:11:06 -0400
From: "=?iso-8859-15?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>
Organization: Remlab.net
To: Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH] phonet: Check input from user before allocating
Date: Mon, 2 Apr 2012 22:01:40 +0300
User-Agent: KMail/1.13.7 (Linux/3.3.0basile-00001-g000ecb0; KDE/4.7.4; i686; ; )
Cc: remi.denis-courmont@nokia.com, davem@davemloft.net, davej@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1333398660-11552-1-git-send-email-levinsasha928@gmail.com>
In-Reply-To: <1333398660-11552-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Message-Id: <201204022201.41808.remi@remlab.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 2 avril 2012 23:31:00 Sasha Levin, vous avez écrit :
> A phonet packet is limited to USHRT_MAX bytes, this is never checked during
> tx which means that the user can specify any size he wishes, and the kernel
> will attempt to allocate that size.

Does this really solve the problem?  I guess 128kb is still possible with 
USHRT_MAX plus skbuff overhead, which might still trigger OOM relatively 
easily once the memory gets sufficiently fragmented.

How does UDP deal with this?

-- 
Rémi Denis-Courmont
http://www.remlab.net/
http://fi.linkedin.com/in/remidenis
