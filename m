Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab1IGTF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:05:26 -0400
Received: from claw.goop.org ([74.207.240.146]:53160 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754474Ab1IGTFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:05:25 -0400
Message-ID: <4E67C06E.1030905@goop.org>
Date: Wed, 07 Sep 2011 12:05:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v3 2/2] xen: modify kernel mappings corresponding to granted
 pages
References: <alpine.DEB.2.00.1109071723470.12963@kaball-desktop> <1315413571-10938-2-git-send-email-stefano.stabellini@eu.citrix.com> <4E67A646.7000405@goop.org> <alpine.DEB.2.00.1109071825180.12963@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1109071825180.12963@kaball-desktop>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 10:38 AM, Stefano Stabellini wrote:
>
>> But also, this pattern of getting results back from batched calls is
>> unusual - actually, I think this is unique.  If you have batched up a
>> map operation which has its map_op args allocated from the multicall
>> buffer, then the flush will implicitly free them as well, so it isn't
>> valid to read back from the structure later on.  If you want to have an
>> args structure you can use once the hypercall has been issued, you need
>> to manually manage its lifetime.
> But I am not using the multicall buffer as argument, I am using the
> kmap_op passed to m2p_add_override.

Yep, I overlooked that.

    J
