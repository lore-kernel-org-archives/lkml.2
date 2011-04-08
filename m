Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723Ab1DHX0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 19:26:42 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52320 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab1DHX0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 19:26:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=lCYauodsWxgnIfEbOguSjpznM+DCuotVbfIXvBIdFPj0nXz4PfFKglkRto65denNIB
         xjfyeXXnVskndHW8QeLDQexIWW3kGujs8taL6fQYPVAKQ7e1xopVoAvq9vaMAF+JS4KE
         /kjyRptrzdzDJ/zO6ueVQJ7rsI5zG1dIe2pRI=
Message-ID: <4D9F99AA.8060803@gmail.com>
Date: Fri, 08 Apr 2011 17:26:34 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        KVM mailing list <kvm@vger.kernel.org>
Subject: Re: trace-cmd errors on kvm events
References: <4D9F59AC.6080707@gmail.com> <4D9F790B.2000300@web.de> <4D9F7A4B.3040606@gmail.com> <4D9F7BC0.8010003@web.de>
In-Reply-To: <4D9F7BC0.8010003@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/11 15:18, Jan Kiszka wrote:
> Let me check... indeed, I'm getting the same file-not-found here with
> trace-cmd.git 9cce1c9b5b when starting it directly from its build directory.
> 
> But maybe your trace-cmd or kernel versions are too old / incompatible.
> I'm not getting complaints about unparseable events with the above
> snapshot and 2.6.38.

2.6.38.2 kernel, trace-cmd 3e8b5b8 which is March 18 (though git pull
done this morning).

For grins I checked-out 9cce1c9b5b and same error:
trace-cmd record -e kvm -- sleep 1
trace-cmd report 2>&1  | less

You do have to put stderr onto stdout to see the messages I reported
earlier. Or look for [FAILED TO PARSE] on the kvm_exit and
kvm_emulate_insn lines.

David

