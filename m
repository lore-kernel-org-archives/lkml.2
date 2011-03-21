Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1CUR6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 13:58:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab1CUR6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 13:58:11 -0400
Date: Mon, 21 Mar 2011 18:48:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 8/8] job control: Don't send duplicate job control stop
	notification while ptraced
Message-ID: <20110321174845.GA31039@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299614199-25142-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Tejun Heo wrote:
>
>  static bool task_participate_group_stop(struct task_struct *task)
>  {
> @@ -284,7 +288,11 @@ static bool task_participate_group_stop(struct task_struct *task)
>  	if (!WARN_ON_ONCE(sig->group_stop_count == 0))
>  		sig->group_stop_count--;
>  
> -	if (!sig->group_stop_count) {
> +	/*
> +	 * Tell the caller to notify completion iff we are entering into a
> +	 * fresh group stop.  Read comment in do_signal_stop() for details.
> +	 */
> +	if (!sig->group_stop_count && !(sig->flags & SIGNAL_STOP_STOPPED)) {
>  		sig->flags = SIGNAL_STOP_STOPPED;
>  		return true;

Ah, indeed. And this fixes the problems with the extra notification I
mentioned when I was looking at 1/8.

Oleg.

