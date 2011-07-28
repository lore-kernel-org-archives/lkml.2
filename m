Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab1G1XXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:23:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54663 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab1G1XXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:23:44 -0400
Date: Fri, 29 Jul 2011 03:23:37 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Serge Hallyn <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        containers@lists.linux-foundation.org, dhowells@redhat.com,
        ebiederm@xmission.com
Subject: Re: [PATCH 05/14] userns: clamp down users of cap_raised
Message-ID: <20110728232337.GA9186@albatros>
References: <1311706717-7398-1-git-send-email-serge@hallyn.com>
 <1311706717-7398-6-git-send-email-serge@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311706717-7398-6-git-send-email-serge@hallyn.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 18:58 +0000, Serge Hallyn wrote:
> From: Serge E. Hallyn <serge.hallyn@canonical.com>
> 
> A few modules are using cap_raised(current_cap(), cap) to authorize
> actions, but the privilege should be applicable against the initial
> user namespace.  Refuse privilege if the caller is not in init_user_ns.
> 
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  drivers/block/drbd/drbd_nl.c           |    5 +++++
>  drivers/md/dm-log-userspace-transfer.c |    3 +++
>  drivers/staging/pohmelfs/config.c      |    3 +++
>  drivers/video/uvesafb.c                |    3 +++
>  4 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
> index 515bcd9..7717f8a 100644
> --- a/drivers/block/drbd/drbd_nl.c
> +++ b/drivers/block/drbd/drbd_nl.c
> @@ -2297,6 +2297,11 @@ static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms
>  		return;
>  	}
>  
> +	if (current_user_ns() != &init_user_ns) {
[...]
>  	if (!cap_raised(current_cap(), CAP_SYS_ADMIN)) {
[...]

Looks like it is an often pattern.  Maybe move both checks to a
function?


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
