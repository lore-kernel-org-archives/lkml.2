Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2FSTto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:49:44 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:22204 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab2FSTtn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:49:43 -0400
MIME-Version: 1.0
Message-ID: <c10bcaf9-aa56-4d6a-bc2c-310096b4198b@default>
Date: Tue, 19 Jun 2012 12:49:13 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Konrad Wilk <konrad.wilk@oracle.com>, Nitin Gupta <ngupta@vflare.org>
Subject: RE: [PATCH 02/10] zcache: fix refcount leak
References: <4FE0392E.3090300@linux.vnet.ibm.com>
 <4FE03949.4080308@linux.vnet.ibm.com> <4FE08C9A.3010701@linux.vnet.ibm.com>
In-Reply-To: <4FE08C9A.3010701@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Tuesday, June 19, 2012 8:29 AM
> To: Xiao Guangrong
> Cc: Andrew Morton; Dan Magenheimer; LKML; linux-mm@kvack.org
> Subject: Re: [PATCH 02/10] zcache: fix refcount leak
> 
> On 06/19/2012 03:33 AM, Xiao Guangrong wrote:
> 
> > In zcache_get_pool_by_id, the refcount of zcache_host is not increased, but
> > it is always decreased in zcache_put_pool
> >
> > Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> 
> Acked-by: Seth Jennings <sjenning@linux.vnet.ibm.com>

(Nitin Gupta and Konrad Wilk cc'ed to call their attention
to this patch sequence...)

My preference would be to fix it the opposite way, by
checking and ignoring zcache_host in zcache_put_pool.
The ref-counting is to ensure that a client isn't
accidentally destroyed while in use (for multiple-client
users such as ramster and kvm) and since zcache_host is a static
struct, it should never be deleted so need not be ref-counted.

Dan
