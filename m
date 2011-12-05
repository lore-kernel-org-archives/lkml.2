Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab1LEVix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 16:38:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36491 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756127Ab1LEVii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 16:38:38 -0500
Date: Mon, 5 Dec 2011 13:38:32 -0800
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: gregkh@suse.de, dhowells@redhat.com, eparis@redhat.com, rjw@sisk.pl,
        kay.sievers@vrfy.org, jmorris@namei.org, bp@amd64.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] PM / Usermodehelper: Introduce reference counting
 to solve usermodehelper_disabled race
Message-ID: <20111205213832.GM627@google.com>
References: <20111205212456.27496.35812.stgit@srivatsabhat.in.ibm.com>
 <20111205212524.27496.58775.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205212524.27496.58775.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 02:56:15AM +0530, Srivatsa S. Bhat wrote:
> This patch adds the necessary synchronization framework to fix the race
> condition with the 'usermodehelper_disabled' flag, by implementing a
> refcounting solution. Specifically, it introduces the pair get_usermodehelper()
> and put_usermodehelper(), which can be used by the readers (those who want to
> read the value of the usermodehelper_disabled flag, such as _request_firmware()
> in this case). The writers (those who enable/disable usermodehelpers by
> setting/resetting that flag) can use the pair umh_control_begin() and
> umh_control_done().
> 
> The reason for using a refcounting solution and not just a plain mutex, is
> that we don't want to unnecessarily serialize all users of request_firmware(),
> which act as readers. But note that we cannot use reader-writer locks here
> because the readers sleep (waiting for the firmware load from user-space),
> and sleeping with spinlocks held is not allowed. So refcounting implemented
> using mutex locks underneath, seems to be the best fit here.

I haven't really read the patch yet but, from the description, why not
use rwsem?

Thanks.

-- 
tejun
