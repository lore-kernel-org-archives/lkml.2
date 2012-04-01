Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab2DAQGw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:06:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51683 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628Ab2DAQGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:06:49 -0400
X-Sasl-enc: Wyws/AegIr+Pp50lxrtUPhA7Y4S7ztqQCNkohUqym8fy 1333296408
Date: Sun, 1 Apr 2012 09:06:47 -0700
From: Greg Kroah-Hartmann <greg@kroah.com>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver-core: devtmpfs - substitute (unreliable) device
 names with UUIDs
Message-ID: <20120401160647.GB17647@kroah.com>
References: <1333285936.19043.5.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333285936.19043.5.camel@mop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 01, 2012 at 03:12:16PM +0200, Kay Sievers wrote:
> From: Kay Sievers <kay@vrfy.org>
> Subject: driver-core: devtmpfs - substitute (unreliable) device names with UUIDs
> 
> For historic reasons, Linux uses very short abbreviated names for device nodes.
> Recent userspace development added various abstractions to access /dev, so that
> this is no longer necessary and we are able to switch almost all of them to
> proper UUIDs, which are better machine-readable, more extensible and future
> proof.
> 
> There is no need in the future to coordinate device names, or namespace them,
> the pool if IDs is just large enough to prevent any conflicts.
> 
> In this patch, for now, the 'memory' device nodes are excluded from that list,
> and /dev/null will still be created to support legacy systems, or to be able
> to boot directly with init=/bin/sh in a non-ported legacy shell binary.
> 
> This is the first part of a series of upcoming changes. We are working on and
> propose a similar scheme for the subsystem names in /sys, cgroups, network
> interfaces names. The other patches will be submitted when they have seen
> more testing, but all looks promising so far.
> 
> This is probably not appropriate for -stable, but we are currently working on
> making this feature configurable, so that it can be safely backported to older
> kernels.
> 
> This is an example output from a 3.4+ kernel:
> 
>   $ sh-4.2# ls -l /dev 
>   total 0
>     4,  17 Apr  1 14:47 0507f057-707a-4390-bcbc-28f7b8cea649
>     4,  64 Apr  1 14:47 075d204b-1eaf-4fa9-9e31-f08a3dd6783d
>    10, 228 Apr  1 14:47 07c45fc1-d32c-4bde-99f2-ebf746ab0d70
>     4,  45 Apr  1 14:47 0ddd2345-c18f-4ea4-a85d-eff1be877d9a
>     4,  66 Apr  1 14:47 135ba1fb-019e-409b-922a-38ede939384f
>     4,  38 Apr  1 14:47 176eee40-89ce-45b8-bf36-0caee0aded21
>     7,   0 Apr  1 14:47 18074259-9dad-4700-9ad0-48bee2cdd677
>     4,   8 Apr  1 14:47 1989db1b-317e-44a2-bf31-f874c9091b12
>     4,  49 Apr  1 14:47 1be81e3a-02ee-437b-9163-3b448b8909a0
>   254,   0 Apr  1 14:47 1c68dffe-a80a-44f4-a956-2d4a2d1bd897
>     7, 128 Apr  1 14:47 1d78abd2-3f49-43b0-8497-715ed06dfc0a
>     4,  23 Apr  1 14:47 1ebce641-d889-4088-b14e-c5edbc52ecfc
>     4,  50 Apr  1 14:47 21df754f-a826-4162-b687-8c4a35f68b91
>     4,  34 Apr  1 14:47 22378a55-7c3f-4ea2-a8a7-c01e1c5ab756
>     4,  39 Apr  1 14:47 2254905d-b071-427c-8566-cfd4b1a31524
>     5,   0 Apr  1 14:47 22dae2a8-862a-4a4e-ab46-25a7c0177f9e
>     4,  59 Apr  1 14:47 2491d450-fad2-40bc-9563-4d65c3c68ce0
>     4,  67 Apr  1 14:47 2a975f05-f3b4-48e4-af2b-b2b0712de780
>     4,  55 Apr  1 14:47 2ae0c894-0a67-4610-a05d-ff2aae1d0d64
>   253,   0 Apr  1 14:47 2d0058bb-38b9-438d-8aaa-b7d9e02991f8
>     4,  61 Apr  1 14:47 2d4c584e-8f19-48b4-9f50-67a46839b950
>     5,   1 Apr  1 14:47 2e6ab566-7919-4d5a-b0e6-664a5d066b30
>    10,  62 Apr  1 14:47 2e85a7c8-bd1d-4263-b79d-947423368beb
>     4,  58 Apr  1 14:47 3000ffd8-3d35-4350-bfbc-225ac991f653
>     4,   0 Apr  1 14:47 33959aa5-3834-4944-82eb-1560a5226d94
>     4,   7 Apr  1 14:47 33b969a4-5cc5-40ea-9494-5316a65f8cd6
>    10, 227 Apr  1 14:47 34aff009-3a8b-4a01-827e-f5a9975c2058
>     4,  20 Apr  1 14:47 3f2491aa-bcb1-4948-a20f-15f6a07bf70c
>     4,   5 Apr  1 14:47 42c194bb-82b9-4823-966e-1328d75ab3e6
>     4,  44 Apr  1 14:47 43f0ade0-4588-4944-9ec5-089c9ae359e0
>     4,  29 Apr  1 14:47 44d0411d-8ff1-4fe2-bf6e-44679e08c03c
>     4,  37 Apr  1 14:47 46cbdd3b-bd2e-446f-94a2-837811e4a7f8
>     4,   6 Apr  1 14:47 473a613d-1ae5-47e2-8c55-6f76bb83be53
>     4,  46 Apr  1 14:47 4802c9ef-0162-40e6-996f-59ded6badd2a
>     4,  21 Apr  1 14:47 4a402517-0bef-4814-8671-4ea5c13279d1
>     4,  47 Apr  1 14:47 4cc6b5b0-2baa-43df-a2f1-0d38ddb17ed1
>     4,   3 Apr  1 14:47 4e87cf2a-448d-4dad-a4c9-00a14d5a6c8b
>     4,   1 Apr  1 14:47 5409fb4c-62b9-4467-9be2-0063bb7ed7fe
>     4,  16 Apr  1 14:47 554e8e04-0e27-4420-bcf6-5d8acc897706
>     4,  30 Apr  1 14:47 55a1fef8-e286-401e-9b00-62ae190985a8
>     4,  13 Apr  1 14:47 577b1fd0-9606-4b46-8e15-a84a5758b6be
>     4,  56 Apr  1 14:47 5867cffc-636a-4625-beb7-1077f7e1c4a4
>     4,  57 Apr  1 14:47 5c8de8e8-824b-49c7-ba28-2fba017285b7
>     4,  28 Apr  1 14:47 5e4b3c75-62e7-417e-8f54-fc2ce49a418f
>     4,  54 Apr  1 14:47 624f2852-0bde-497a-88a6-c4a6d8fd739c
>     4,  41 Apr  1 14:47 645a47a6-902d-4870-95df-26170348285b
>     4,  48 Apr  1 14:47 66666ae9-bfaf-478f-9773-3fbb275dfd8b
>     4,  60 Apr  1 14:47 67b7f875-c80a-4b40-b619-0af37041d1ab
>     4,  32 Apr  1 14:47 69278743-4cfa-48d3-ae82-7534c61a60b7
>     4,  24 Apr  1 14:47 6a82c453-a38d-490f-82ce-4d021ae123cd
>     4,  15 Apr  1 14:47 6ac64fb5-c52c-451e-8146-8a796b7351bd
>     4,  33 Apr  1 14:47 71614a99-cc50-4fd5-8a8a-ece7009de1ab
>     4,  19 Apr  1 14:47 7682c236-2b58-4beb-b1e1-5a00f3a1cc46
>     4,  10 Apr  1 14:47 76b2adf3-ddd6-46e6-9024-831cad4786a7
>     4,  51 Apr  1 14:47 774e198a-96a8-434b-957a-d20cd3590f01
>    10,   1 Apr  1 14:47 7b503243-9b10-4d83-bb07-a057a7d4abac
>     7, 129 Apr  1 14:47 7d0bee34-abbd-4f1c-80a9-3eed29ad11e9
>     4,  42 Apr  1 14:47 7d627d64-520d-4cd9-ac3d-42d22a876aed
>     4,   2 Apr  1 14:47 834d656e-488a-4c0a-894c-aba4bff74b9c
>     4,  18 Apr  1 14:47 85d5061c-dd48-4804-a6cb-a22d26d91a5e
>     4,   4 Apr  1 14:47 882f3674-2b74-42f7-b64b-80b4e01b3dd0
>     4,  64 Apr  1 14:47 8e693fd0-a50e-465d-9c0b-a74e41943dbb
>     4,  35 Apr  1 14:47 8ec6b3e6-8d72-4ad9-aba9-8a91ef3f2c3b
>     4,  31 Apr  1 14:47 9a29e09a-7cae-4d68-8ba0-99d103a12900
>     4,  63 Apr  1 14:47 9ccf9199-ae2c-4843-a764-36ed02e88dba
>     5,   2 Apr  1 14:47 a07ff4c4-ac59-4496-ad43-d6f95414fc7b
>    13,  63 Apr  1 14:47 a93508ca-af17-495a-b0d0-09870e1897b7
>    10,  61 Apr  1 14:47 ace2077a-e328-42b5-b403-63d97978832f
>     4,  40 Apr  1 14:47 afadf815-4671-4602-8b90-86b5be540d2b
>     4,  62 Apr  1 14:47 b24c5416-25f2-4349-88c6-7ebb610910b1
>     8,   3 Apr  1 14:47 b2e91dad-3137-4294-b6d1-8a9b3e868883
>     7,   1 Apr  1 14:47 b7087629-68a1-4c8f-8548-395c50a3e810
>     4,  11 Apr  1 14:47 b7c70fed-aea9-47b9-b480-fd5905c960f0
>     4,  52 Apr  1 14:47 b96d8283-538d-4d1e-afa1-10341a3ab4b5
>     4,   9 Apr  1 14:47 bc32ed02-00d5-4ccf-b8b5-e4eb382a5b68
>    10, 235 Apr  1 14:47 bc4e4e01-1754-41dc-9482-345076660cbd
>     8,   4 Apr  1 14:47 be68b2f4-568e-466c-a287-a7d89670b5ea
>    10, 234 Apr  1 14:47 c3105ce0-1fa9-47ec-a0e6-bf8cf72d380b
>     4,  12 Apr  1 14:47 c5279776-5d30-417f-8e58-fd142960638a
>     4,  65 Apr  1 14:47 c7f1cf12-2da8-49c9-886b-ad99d9c5cd41
>     8,   2 Apr  1 14:47 c9b0b801-2117-42cf-9720-4d10678c6227
>     8,   0 Apr  1 14:47 ce9c6e97-be60-4637-9c00-23abb2d40dfa
>     8,   1 Apr  1 14:47 d0098815-5fee-4818-85c0-06002273319e
>     4,  26 Apr  1 14:47 d3edd26e-6a39-49b7-8653-ad7a322c5ffc
>   253,   1 Apr  1 14:47 d56b4e1e-9331-4a20-8b56-2be2ee0508f6
>     4,  22 Apr  1 14:47 df4023ec-ce6a-408c-a96a-3dec9883e625
>     4,  27 Apr  1 14:47 e0d51a34-4a4a-4da7-b580-38cf5432744f
>     4,  53 Apr  1 14:47 e26ad6e6-d8e2-48be-8d2c-2f0b16abff08
>    13,  32 Apr  1 14:47 ec8358f2-3e38-4e06-bd2c-68bde8ec7d1b
>     4,  36 Apr  1 14:47 ef941460-6397-4126-bd23-d55ee8b520aa
>     4,  14 Apr  1 14:47 f1341ce0-9475-4113-aff3-5cbf926a41ef
>     4,  25 Apr  1 14:47 f4663273-d255-4151-bde9-feb7593a427e
>     4,  43 Apr  1 14:47 f52e3619-5765-4942-9d70-3553195cec99
>    10,  63 Apr  1 14:47 fe0dde7a-4047-41c1-ae55-548d20dad81a
>     1,   7 Apr  1 14:47 full
>     1,   2 Apr  1 14:47 kmem
>     1,  11 Apr  1 14:47 kmsg
>     1,   1 Apr  1 14:47 mem
>     1,   3 Apr  1 14:47 null
>     1,   4 Apr  1 14:47 port
>     1,   8 Apr  1 14:47 random
>     1,   9 Apr  1 14:47 urandom
>     1,   5 Apr  1 14:47 zero

Nice job, now applied, thanks.

greg k-h
