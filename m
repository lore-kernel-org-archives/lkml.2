Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab0KQNNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:13:10 -0500
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:52202 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab0KQNNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:13:08 -0500
Message-ID: <4CE3D4D3.7020306@linux.vnet.ibm.com>
Date: Wed, 17 Nov 2010 11:12:51 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: David Safford <safford@watson.ibm.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        linux-crypto@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH v1.3 2/4] key: add tpm_send command
References: <1289599613.4341.64.camel@localhost.localdomain> <1289514356.2726.18.camel@localhost.localdomain> <1289404309-15955-3-git-send-email-zohar@linux.vnet.ibm.com> <1289404309-15955-1-git-send-email-zohar@linux.vnet.ibm.com> <6651.1289504931@redhat.com> <22962.1289571072@redhat.com> <1289573330.4341.31.camel@localhost.localdomain> <4CDDB0A2.7090606@linux.vnet.ibm.com> <28655.1289599899@redhat.com>
In-Reply-To: <28655.1289599899@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/10 20:11, David Howells wrote:
> David Safford<safford@watson.ibm.com>  wrote:
>
>> David, does this look ok to you? If so, I will do two patches, one to
>> fix the helper name throughout the existing tpm.c, and then a new
>> version of the tpm_send patch which uses the new name.
> I prefer my suggestion: Wrapping the module_put() up so that you don't see it
> directly.  Then you don't need to alter tpm_chip_find_get().  I'll argue that
> you don't need to know how tpm_chips are got/put, except in the code that
> wraps it.
>
tpm_chip_find_get() not only gets the tpm_chip, but also searches for it 
given an index in a tpm_chip_list.
tpm_chip_put() is then the name that fits the argument here, given it'll 
only be a wrapper of the tpm_chip put
functionality, not the searching one I assume.

I'll ack any of the two approaches (tpm_chip_put or tpm_chip_find_get 
renaming) in any case.

Rajiv

