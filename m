Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab2FSU3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 16:29:35 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36986 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab2FSU3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 16:29:34 -0400
Message-ID: <4FE0DBDD.2090005@linux.vnet.ibm.com>
Date: Tue, 19 Jun 2012 15:06:53 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Konrad Wilk <konrad.wilk@oracle.com>, Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH 02/10] zcache: fix refcount leak
References: <4FE0392E.3090300@linux.vnet.ibm.com> <4FE03949.4080308@linux.vnet.ibm.com> <4FE08C9A.3010701@linux.vnet.ibm.com> <c10bcaf9-aa56-4d6a-bc2c-310096b4198b@default>
In-Reply-To: <c10bcaf9-aa56-4d6a-bc2c-310096b4198b@default>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061920-1780-0000-0000-0000069B54CC
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000282; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00149494; UDB=6.00034005; UTC=2012-06-19
 20:29:32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 02:49 PM, Dan Magenheimer wrote:

> My preference would be to fix it the opposite way, by
> checking and ignoring zcache_host in zcache_put_pool.
> The ref-counting is to ensure that a client isn't
> accidentally destroyed while in use (for multiple-client
> users such as ramster and kvm) and since zcache_host is a static
> struct, it should never be deleted so need not be ref-counted.


If we do that, we'll need to comment it.  If we don't, it won't be
obvious why we are refcounting every zcache client except one.  It'll
look like a bug.

--
Seth

