Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518Ab0CPXws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 19:52:48 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:51053 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab0CPXwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 19:52:47 -0400
Authentication-Results: sj-iport-3.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEO2n0urR7Ht/2dsb2JhbACbBHOhYJh6hHYEgxo
X-IronPort-AV: E=Sophos;i="4.49,653,1262563200"; 
   d="scan'208";a="217453007"
From: Roland Dreier <rdreier@cisco.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, Or Gerlitz <ogerlitz@voltaire.com>
Subject: Re: [PATCH 1/1] infiniband: ulp/iser, fix error retval in iser_create_ib_conn_res
References: <1268750962-13547-1-git-send-email-jslaby@suse.cz>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 16 Mar 2010 16:52:43 -0700
In-Reply-To: <1268750962-13547-1-git-send-email-jslaby@suse.cz> (Jiri Slaby's
	message of "Tue, 16 Mar 2010 15:49:22 +0100")
Message-ID: <ada634v9644.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 >  	ib_conn->login_buf = kmalloc(ISER_RX_LOGIN_SIZE, GFP_KERNEL);
 >  	if (!ib_conn->login_buf) {
 > -		goto alloc_err;
 >  		ret = -ENOMEM;
 > +		goto alloc_err;
 >  	}

This looks like a valid fix but it's the same part of the code that Dan
found more extensive bugs in.  Or, can I assume you'll sort this out and
make sure a final patch is sorted out?

Thanks,
  Roland
-- 
Roland Dreier  <rolandd@cisco.com>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
