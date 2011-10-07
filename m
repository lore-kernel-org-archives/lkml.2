Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379Ab1JGKiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 06:38:46 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5694 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759825Ab1JGKio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 06:38:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Rc87bRh3oLW+1c+ZxpsZU6iEpaWswyLJtM22ZCWal/luE4nDcXy7WndP+i4NVmAs8
	Q/dIPXO0eMmqkp0Ht4ZPA==
MIME-Version: 1.0
In-Reply-To: <20111006153229.GJ14482@one.firstfloor.org>
References: <1317912555-9559-1-git-send-email-eranian@google.com>
	<1317912555-9559-8-git-send-email-eranian@google.com>
	<20111006153229.GJ14482@one.firstfloor.org>
Date: Fri, 7 Oct 2011 12:38:40 +0200
Message-ID: <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com>
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, ming.m.lin@intel.com, robert.richter@amd.com,
        ravitillo@lbl.gov
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 5:32 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> +     kernel_insn_init(&insn, kaddr);
>> +     insn_get_opcode(&insn);
>
> This makes me uncomfortable. AFAIK that's the first use of the opcode
> decoder being used directly for user space. It has a quite large attack
> surface. Who says it cannot be exploited?
>
This is not new, it's already used for the PEBS fixups and that includes
user level fixups, if possible.

We are not executing the instruction here, just decoding it to filter it out
from a buffer if necessary.

> -Andi
> --
> ak@linux.intel.com -- Speaking for myself only.
>
