Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab2IGUef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 16:34:35 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51690 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756864Ab2IGUe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 16:34:29 -0400
Message-ID: <504A5A51.5060609@redhat.com>
Date: Fri, 07 Sep 2012 22:34:25 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, hch@lst.de,
        roland@kernel.org
Subject: Re: [PATCH 06/11] target: go through normal processing for zero-length
 REQUEST_SENSE
References: <1347031842-2531-1-git-send-email-pbonzini@redhat.com>  <1347031842-2531-7-git-send-email-pbonzini@redhat.com>  <1347042182.4162.634.camel@haakon2.linux-iscsi.org> <1347042809.4162.640.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1347042809.4162.640.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/09/2012 20:33, Nicholas A. Bellinger ha scritto:
>>> > >  	if (!cmd->data_length &&
>>> > > +	    cmd->t_task_cdb[0] != REQUEST_SENSE &&
>>> > >  	    (cmd->se_dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV ||
>>> > >  	     cmd->t_task_cdb[0] == REPORT_LUNS) {
>>> > >  		spin_lock_irq(&cmd->t_state_lock);
> Btw, this section does not compile.

The idea was to add the missing parenthesis to

cmd->t_task_cdb[0] == REPORT_LUNS))

but your fix is also correct after patch 3.

Thanks!

Paolo
