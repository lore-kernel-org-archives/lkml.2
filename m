Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098Ab2IFAlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 20:41:44 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:33233 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052Ab2IFAll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 20:41:41 -0400
Subject: Re: [PATCH 3.6 0/3] Fix use-after-free in PSCSI
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org
In-Reply-To: <1346857755-10224-1-git-send-email-pbonzini@redhat.com>
References: <1346857755-10224-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Sep 2012 17:41:39 -0700
Message-ID: <1346892099.4162.325.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 17:09 +0200, Paolo Bonzini wrote:
> Hi,
> 
> this series fixes the bug I reported with wrong sense data.  The
> memory corruption is caused by using the sense data after freeing
> it.  The series corrects it by moving the copy of the sense data
> earlier, to the transport_complete callback.
> 
> Please review and be kind on my first lio patches! :)
> 
> Paolo
> 
> Paolo Bonzini (3):
>   target: move transport_get_sense_data
>   target: simplify code around transport_get_sense_data
>   target: fix use-after-free with PSCSI sense data
> 
>  drivers/target/target_core_pscsi.c     |   21 ++----
>  drivers/target/target_core_transport.c |  117 ++++++++++++--------------------
>  include/target/target_core_backend.h   |    4 +-
>  3 files changed, 53 insertions(+), 89 deletions(-)
> 

The approach to squash the bug looks easonable to me, and nice work on
the extra cleanups for backend sense w/ TRANSPORT_PLUGIN_PHBA_PDEV !

I've applied this to target-pending/master w/ CC stable, and will plan
to send out the PULL request for -rc5 over the next days.

Nice work Paolo!

--nab

