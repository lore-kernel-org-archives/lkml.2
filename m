Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab0FVOLI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 10:11:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:18797 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab0FVOLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 10:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=H4Ky+tIzqxlWeYtLMAc6KuQ+ohaXhC6zcqxf5pGsgQ5/iMpbMbuy8fkwlvTsa02Rw5
         qXgI9zDwG62wCBT5xldWCmvW1fezECQuks6b4HRUN/uhZA9hW92GfqM4feaY4cyZpukW
         cw4ZxRtT8xZtiW9z2rbsJypX5JYizyQcMpIuE=
Message-ID: <4C20C478.9030505@gmail.com>
Date: Tue, 22 Jun 2010 16:11:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: intel_cacheinfo: potential NULL dereference?
References: <4C209C15.9090604@gmail.com> <4C209C6E.3060302@gmail.com> <20100622130825.GB27658@aftab>
In-Reply-To: <20100622130825.GB27658@aftab>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2010 03:08 PM, Borislav Petkov wrote:
> From: Jiri Slaby <jirislaby@gmail.com>
> Date: Tue, Jun 22, 2010 at 07:20:14AM -0400
> 
>> On 06/22/2010 01:18 PM, Jiri Slaby wrote:
>>> Stanse found, that this_leaf->l3 is dereferenced at <<1>>, but checked
>>> for being NULL at <<2>>. Is the check superfluous or the dev assignment
>>> should go after the check?
>>
>> Oh, and I have another report with same symptoms for show_cache_disable.
> 
> Right, so I have a patch in tip/x86/cpu
> (8cc1176e5de534d55cb26ff0cef3fd0d6ad8c3c0) which reorganizes
> and cleans up that code. With it, all possible checks land in
> amd_check_l3_disable() and if they have all been passed, the PCI dev is
> guaranteed to be properly set. So no need for sprinkling additional NULL
> checks in the code.
> 
> How's that?

Looks good.

thanks,
-- 
js
