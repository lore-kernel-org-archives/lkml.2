Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab2FTW01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:26:27 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26356 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab2FTW0Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:26:25 -0400
MIME-Version: 1.0
Message-ID: <db70ea46-7e43-4795-a399-c3220cda0a46@default>
Date: Wed, 20 Jun 2012 15:25:52 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Konrad Wilk <konrad.wilk@oracle.com>, Nitin Gupta <ngupta@vflare.org>
Subject: RE: [PATCH 02/10] zcache: fix refcount leak
References: <4FE0392E.3090300@linux.vnet.ibm.com>
 <4FE03949.4080308@linux.vnet.ibm.com> <4FE08C9A.3010701@linux.vnet.ibm.com>
 <c10bcaf9-aa56-4d6a-bc2c-310096b4198b@default>
 <4FE0DBDD.2090005@linux.vnet.ibm.com> <4FE13B76.6020703@linux.vnet.ibm.com>
 <4FE14149.7030807@linux.vnet.ibm.com>
In-Reply-To: <4FE14149.7030807@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Xiao Guangrong [mailto:xiaoguangrong@linux.vnet.ibm.com]
> Subject: Re: [PATCH 02/10] zcache: fix refcount leak
> 
> On 06/20/2012 10:54 AM, Xiao Guangrong wrote:
> 
> > On 06/20/2012 04:06 AM, Seth Jennings wrote:
> >
> >> On 06/19/2012 02:49 PM, Dan Magenheimer wrote:
> >>
> >>> My preference would be to fix it the opposite way, by
> >>> checking and ignoring zcache_host in zcache_put_pool.
> >>> The ref-counting is to ensure that a client isn't
> >>> accidentally destroyed while in use (for multiple-client
> >>> users such as ramster and kvm) and since zcache_host is a static
> >>> struct, it should never be deleted so need not be ref-counted.
> >>
> >>
> >> If we do that, we'll need to comment it.  If we don't, it won't be
> >> obvious why we are refcounting every zcache client except one.  It'll
> >> look like a bug.
> >
> >
> > Okay, i will fix it like Dan's way and comment it.
> 
> Hmm...But i notice that zcache_host is the same as other clients, all
> of them are static struct:
> 
> | static struct zcache_client zcache_host;
> | static struct zcache_client zcache_clients[MAX_CLIENTS];
> 
> And all of them are not destroyed.

Yes, the code currently in zcache was a first step towards
supporting multiple clients.  Ramster goes one step further
and kvm will require even a tiny bit more work.

FYI, I'm working on a unification version of zcache that can support
all of these cleanly as well as better support for eviction
that will make standalone zcache more suitable for promotion from
staging and enterprise-ready.  Due to various summer commitments,
it will probably be a few weeks before it is ready for posting.

Dan
