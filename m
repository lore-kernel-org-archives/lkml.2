Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab0K2QPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:15:07 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59425 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab0K2QPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:15:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=RpcNz8nWf9rbB4oBJSLcPYwQ7x71r2/vdVhpWtnDzykcQ9tlgu5n6qSZd1Td9U2taD
         Sb8CZewBtCPY1aDmgRVIozY9Im2CCZRW2261o0TBNDzJd/f8lSwBMRO1IPZRQG2dkX4G
         Ab5wwZFcGhB/POUjyerLMc3Wk6nAxqT93q5fE=
Message-ID: <4CF3D182.8090907@doube.net>
Date: Mon, 29 Nov 2010 16:14:58 +0000
From: Michael Doube <michael@doube.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        "Rafael J. Wysocki" <rjw@suse.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [REGRESSION] Suspend fails because of TPM modules
References: <alpine.LNX.2.00.1011291554570.981@pobox.suse.cz> <alpine.LNX.2.00.1011291614060.981@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1011291614060.981@pobox.suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I just found out, that if I modprobe tpm_tis module with
> 
> 	itpm=1
> 
> parameter, the problem doesn't happen any more and suspend works fine.

Not here unfortunately. Suspend still fails with itpm=1, and I get this
in my logs

Nov 29 15:52:32 doris kernel: [  649.110527] resource map sanity check
conflict: 0xfed40000 0xfed44fff 0xfed43000 0xfed43fff Intel Flush Page
Nov 29 15:52:32 doris kernel: [  649.110923] tpm_tis 00:09: 1.2 TPM
(device-id 0xB, rev-id 16)
Nov 29 15:52:32 doris kernel: [  649.110929] tpm_tis 00:09: Intel iTPM
workaround enabled
Nov 29 15:54:34 doris kernel: [  771.360067] tpm_tis 00:09:
tpm_transmit: tpm_send: error -62

Also, this patch:
http://marc.info/?l=linux-kernel&m=128769741101534&w=2

Looks for a string that is absent from my Vaio SZ650, so the workaround
is not applied (and if it was, it probably wouldn't work, right?).

I posted my DSDT to bugzilla:
https://bugzilla.kernel.org/attachment.cgi?id=38072

Michael
