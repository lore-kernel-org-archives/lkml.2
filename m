Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab1DSXWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:22:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:29999 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1DSXWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:22:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=LRZ9KB6F9LsQ3E+OhMfygqg0r1m3FpHU888sDgXZq5UWk+chYjxnsg7xEHwsvO+XxD
         EhTA56tBRtOM5Al+7qFg==
Date: Tue, 19 Apr 2011 16:22:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: james_p_freyensee@linux.intel.com
cc: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com,
        christophe.guerard@intel.com
Subject: Re: [PATCH 1/4] export kernel call get_task_comm().
In-Reply-To: <1303253889-10074-2-git-send-email-james_p_freyensee@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1104191620360.4300@chino.kir.corp.google.com>
References: <james_p_freyensee@linux.intel.com> <1303253889-10074-2-git-send-email-james_p_freyensee@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011, james_p_freyensee@linux.intel.com wrote:

> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> This allows drivers who call this function to be compiled modularly.
> Otherwise, a driver who is interested in this type of functionality
> has to implement their own get_task_comm() call, causing code
> duplication in the Linux source tree.
> 
> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>

Acked-by: David Rientjes <rientjes@google.com>

There've been some other patchsets proposed recently that need to print a 
thread's comm and since /proc/pid/comm can change the comm's of other 
threads out from under them, it's necessary to serialize access to it with 
task_lock().  This patch certainly makes it easier for modules to do so 
correctly, thanks!
