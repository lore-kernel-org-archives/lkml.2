Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759655Ab0JGH0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 03:26:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59047 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0JGH0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:26:46 -0400
Date: Thu, 7 Oct 2010 09:26:41 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, andi@firstfloor.org,
        robert.richter@amd.com, gorcunov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] arch generic way to trigger unknown NMIs
Message-ID: <20101007072641.GE5010@basil.fritz.box>
References: <20101007030807.GA4076@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101007030807.GA4076@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Having a regression test for this is good, but it would 
be also good if it wasn't a private one but in some public
git repository.

>  static struct jprobe lkdtm;
> @@ -340,6 +343,9 @@ static void lkdtm_do_action(enum ctype which)
>  		set_current_state(TASK_UNINTERRUPTIBLE);
>  		schedule();
>  		break;
> +	case NMI:
> +		apic->send_IPI_allbutself(NMI_VECTOR);
> +		break;
>  	case NONE:
>  	default:
>  		break;
> 
> Anyone have any thoughts?  Maybe there is an easier way?

Do you really want the NMI on all CPUs - 1? Normally it's directed to
a single one.

-Andi
