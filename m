Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab2EBWqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:46:35 -0400
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:36043 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754772Ab2EBWqe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:46:34 -0400
MIME-Version: 1.0
In-Reply-To: <1335591601-26473-1-git-send-email-levinsasha928@gmail.com>
References: <1335591601-26473-1-git-send-email-levinsasha928@gmail.com>
From: Roland Dreier <roland@kernel.org>
Date: Wed, 2 May 2012 15:46:12 -0700
X-Google-Sender-Auth: 166fCxhuBG_KuVadgdWXYJh9S8A
Message-ID: <CAL1RGDUVmK4T=-SJOQz6KFQhbjkMnbXUaxU0-eyWDH-bXMNtQA@mail.gmail.com>
Subject: Re: [PATCH] RDMA/ocrdma: Don't sleep in atomic notifier handler
To: Sasha Levin <levinsasha928@gmail.com>
Cc: sean.hefty@intel.com, hal.rosenstock@gmail.com, parav.pandit@emulex.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 10:40 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> +       spin_lock(&ocrdma_devlist_lock);
> +       list_add_tail_rcu(&dev->entry, &ocrdma_dev_list);
> +       spin_lock(&ocrdma_devlist_lock);

Er, applied with this fixed to be spin_unlock at the end...
