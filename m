Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab0DWOm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:42:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:60337 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939Ab0DWOmy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:42:54 -0400
Subject: Re: [PATCH 1/8] KVM: SVM: Fix nested nmi handling
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20100423143159.GJ31537@amd.com>
Date: Fri, 23 Apr 2010 16:42:52 +0200
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <768234E2-FF02-42AC-B04C-00D98B19B1C0@suse.de>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com> <1271932394-13968-2-git-send-email-joerg.roedel@amd.com> <622FCBB5-826D-4392-A521-7E395507398B@suse.de> <20100423141355.GD31537@amd.com> <85D89C34-806C-4376-89BA-5BFD413F5396@suse.de> <20100423142258.GG31537@amd.com> <013159C3-277C-447C-B64B-D2196AF851F9@suse.de> <20100423143159.GJ31537@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 23.04.2010, at 16:31, Joerg Roedel wrote:

> On Fri, Apr 23, 2010 at 04:24:54PM +0200, Alexander Graf wrote:
>> 
>> On 23.04.2010, at 16:22, Joerg Roedel wrote:
> 
>>> No, nested_svm_nmi runs in atomic context where we can't emulate a
>>> vmexit. We set exit_required and emulate the vmexit later.
>> 
>> So we modify the L2 rflags and then trigger a #vmexit, leaving the l2
>> state broken?
> 
> No, the rflags are changed in enable_nmi_window which isn't called when
> we run nested and the nested hypervisor intercepts nmi. So it only runs
> in the !nested case where it can't corrupt L2 state.

Last time I checked the code enable_nmi_window was the function triggering the #vmexit, so it should run in that exact scenario. If what you say is true, where do we #vmexit instead then?


Alex

