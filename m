Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751066Ab0IJKPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:15:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36631 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab0IJKPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:15:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=HAv3M0CGf8dP4XbkPcgD0/A2xi0eq8uRWLT1r1pWZWs9qlGL3PeiT90goR7wrS8iJx
         ZcYF7w0GS1f041ldMTQ/M30WJqnO+Q+YycD7q5si9YnILWxCdAbe2dulmWrjznQwN+ZL
         QO2c7sDNx52bs9lT9jIR+oqA24pWn+jCugjAk=
Date: Fri, 10 Sep 2010 10:15:33 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: "Gustavo F. Padovan" <padovan@profusion.mobi>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, marcel@holtmann.org,
        davem@davemloft.net, linux-bluetooth@vger.kernel.org
Subject: Re: Possible regression with skb_clone() in 2.6.36
Message-ID: <20100910101533.GA21844@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283988727-1456-1-git-send-email-padovan@profusion.mobi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-09 01:32, Gustavo F. Padovan wrote:
> I've been experiencing some problems when running the L2CAP Streaming mode in
> 2.6.36. The system quickly runs in an Out Of Memory condition and crash. That
> wasn't happening before, so I think we may have a regression here (I didn't
> find where yet). The crash log is below.
> 
> The following patch does not fix the regression, but shows that removing the
> skb_clone() call from l2cap_streaming_send() we workaround the problem. The
> patch is good anyway because it saves memory and time.
> 
> By now I have no idea on how to fix this.

My suggestion is to check the length of conn->data_q in hci_send_acl()
while this happens, and maybe try to set some limit here.

Jarek P.
