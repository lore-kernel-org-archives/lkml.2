Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab1DSL6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:58:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55679 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1DSL6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:58:07 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] Btrfs: allocate extent state and check the result properly
In-reply-to: <4DACEA40.5020008@cn.fujitsu.com>
References: <4DA409E6.7020406@cn.fujitsu.com> <4DACEA40.5020008@cn.fujitsu.com>
Date: Tue, 19 Apr 2011 07:55:21 -0400
Message-Id: <1303213987-sup-4275@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DAD78CA.0077:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Xiao Guangrong's message of 2011-04-18 21:49:52 -0400:
> On 04/12/2011 04:14 PM, Xiao Guangrong wrote:
> > It doesn't allocate extent_state and check the result properly:
> > - in set_extent_bit, it doesn't allocate extent_state if the path is not
> >   allowed wait
> > 
> > - in clear_extent_bit, it doesn't check the result after atomic-ly allocate,
> >   we trigger BUG_ON() if it's fail
> > 
> > - if allocate fail, we trigger BUG_ON instead of returning -ENOMEM since
> >   the return value of clear_extent_bit() is ignored by many callers
> > 
> 
> Ping...to see what happened. :-)

Sorry, could you please change this to check the results of the atomic
allocatoin in set/clear_extent_bit?  I'd rather not add a new BUG_ON
deeper into the code.

-chris
