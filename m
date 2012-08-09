Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab2HIRuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:50:09 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48138 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757744Ab2HIRuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:50:06 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Subject: Re: [SCSI] qla4xxx: support iscsiadm session mgmt
From: Michael Christie <michaelc@cs.wisc.edu>
In-Reply-To: <20120808165712.GB3734@mwanda>
Date: Thu, 9 Aug 2012 12:49:58 -0500
Cc: manish.rangankar@qlogic.com, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7BIT
Message-Id: <7CB86284-470E-4623-9650-F4C0F1C8DCB1@cs.wisc.edu>
References: <20120614182745.GA6383@elgon.mountain> <20120808150022.GA3734@mwanda> <50228750.3030108@cs.wisc.edu> <20120808165712.GB3734@mwanda>
To: open-iscsi@googlegroups.com
X-Mailer: Apple Mail (2.1485)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 8, 2012, at 11:57 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:

> On Wed, Aug 08, 2012 at 10:35:44AM -0500, Mike Christie wrote:
>> On 08/08/2012 10:00 AM, Dan Carpenter wrote:
>>> I never heard back on this.  This buffer overflow is still present
>>> in the current code.
>>> 
>> 
>> Qlogic just sent a patch yesterday.
>> http://marc.info/?l=linux-scsi&m=134434199930938&w=2
> 
> Ah, good.
> 
> It seems like qla4xxx_ep_connect() should take a pointer to struct
> sockaddr_storage and also dst_addr in qla4xxx_get_ep_fwdb() should
> be changed as well.  As in:
> 
> static struct iscsi_endpoint *
> -qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
> +qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr_storage *dst_addr,
>                    int non_blocking)


Do you mean that should be done to fix a bug or to just make it nicer? I think it will not be a issue bug wise, because it ends up getting cast to the proper struct in the end and the proper size to copy is detected. What actually gets passed that function above is not a struct sockaddr_storage. It is a sockaddr_in or socaddr_in6. It depends on if it is ipv6 or not.

If you are just saying it would be nicer to be consistent in the struct used then it is a larger change that I think should be done in another patch. It will affect other drivers.