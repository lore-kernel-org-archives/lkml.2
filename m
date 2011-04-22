Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab1DVWoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 18:44:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:16446 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab1DVWoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 18:44:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,256,1301900400"; 
   d="scan'208";a="682730006"
Subject: Re: [PATCH] export kernel call get_task_comm().
From: J Freyensee <james_p_freyensee@linux.intel.com>
Reply-To: james_p_freyensee@linux.intel.com
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundattion.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
        suhail.ahmed@intel.com, christophe.guerard@intel.com
In-Reply-To: <alpine.DEB.2.00.1104221534380.3873@chino.kir.corp.google.com>
References: <james_p_freyensee@linux.intel.com>
	 <1303511188-728-2-git-send-email-james_p_freyensee@linux.intel.com>
	 <alpine.DEB.2.00.1104221534380.3873@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 22 Apr 2011 15:43:59 -0700
Message-ID: <1303512239.13457.123.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 15:35 -0700, David Rientjes wrote:
> On Fri, 22 Apr 2011, james_p_freyensee@linux.intel.com wrote:
> 
> > From: J Freyensee <james_p_freyensee@linux.intel.com>
> > 
> > This allows drivers who call this function to be compiled modularly.
> > Otherwise, a driver who is interested in this type of functionality
> > has to implement their own get_task_comm() call, causing code
> > duplication in the Linux source tree.
> > 
> > Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 
> I still suggest that we implement finer-grained protection for tsk->comm 
> through get_task_comm(), though, because it's going to be difficult to 
> know whether task_lock(tsk) is held in all contexts we'll want to call it; 
> task_lock(tsk) is used to protect many members of task_struct.

Okay, but how about accepting this as step 1, then investigate a finer
grained lock structure as step 2?

