Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab2G0Gu0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 02:50:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab2G0GuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 02:50:24 -0400
Message-ID: <50123A24.9040403@redhat.com>
Date: Fri, 27 Jul 2012 08:50:12 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Wang Sen <kelvin.xupt@gmail.com>
CC: Boaz Harrosh <bharrosh@panasas.com>, Wang Sen <senwang@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, JBottomley@parallels.com,
        stefanha@linux.vnet.ibm.com, mc@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: virtio-scsi: Fix address translation failure of
 HighMem pages used by sg list
References: <1343204966-23560-1-git-send-email-senwang@linux.vnet.ibm.com> <500FB1DE.1000100@redhat.com> <CAKviJvVrrtyjFOzu7jmmD7cpXZcXtyQ+7HDy1G1o2_a0JRss5w@mail.gmail.com> <500FE952.9030001@panasas.com> <CAKviJvV00Br4e455+_gdYyg6pdbdDqQnMC2NMTv-3ZyFgxvZ9A@mail.gmail.com>
In-Reply-To: <CAKviJvV00Br4e455+_gdYyg6pdbdDqQnMC2NMTv-3ZyFgxvZ9A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 27/07/2012 05:12, Wang Sen ha scritto:
>> > No this code is correct, though you will need to make sure to properly
>> > terminate the destination sg_list.
> Yes, the terminate marker in the destination list is set when initialization.
> sg_set_page would not break this marker because it saved both the two
> maker bits at sg_asign_page.
> 
> Also, the allocation of destination sg list considered the total number of
> the source sg_list. So, sg_set_page can work correctly.
> 
> The value assignment method also can also work correctly, because the
> termination marker in source sg_list has been set in blk_rq_map_sg(), as
> the last entry of source sg_list is just copied to the the last entry
> in destination
> list.
> 
> Uh, Paolo, Boaz, have  you reached agreement on which method to use?

Let's use the value assignment, and document it in the commit message as
follows:

Value assignment creates a well-formed scatterlist, because the
termination marker in source sg_list has been set in blk_rq_map_sg().
The last entry of the source sg_list is just copied to the the last
entry in destination list.  Note that, for now, virtio_ring does not
care about the form of the scatterlist and simply processes the first
out_num + in_num consecutive elements of the sg[] array.

Paolo
