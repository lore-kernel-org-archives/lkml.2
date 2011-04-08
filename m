Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641Ab1DHSxj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 14:53:39 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:52882 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab1DHSxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 14:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=m9eTSMfQtUyfAfYwgEH+JEmLyNeCKOIHSv69tbjVzkWz7HBgoIrbmsgQ3yyb6kLSNz
         0bhhlnlXSchLbB9AGNScOYkqYGLG/3aBbVatrcAAp0fvQwBk1FbhlfPn9r7R9YaN/jpA
         m7YuVTiXRxnkYwsm3wxG4mrsquXQ3dren6Cyg=
Message-ID: <4D9F59AC.6080707@gmail.com>
Date: Fri, 08 Apr 2011 12:53:32 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        KVM mailing list <kvm@vger.kernel.org>
Subject: trace-cmd errors on kvm events
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38.2 kernel with trace-cmd git pulled this morning:

trace-cmd record -e kvm

trace-cmd report 2>&1 | less

trace-cmd: No such file or directory
  function ftrace_print_symbols_seq not defined
  failed to read event print fmt for kvm_nested_vmexit_inject
  function ftrace_print_symbols_seq not defined
  failed to read event print fmt for kvm_nested_vmexit
  function ftrace_print_symbols_seq not defined
  failed to read event print fmt for kvm_exit
  bad op token {
  failed to read event print fmt for kvm_emulate_insn

        qemu-kvm-1864  [002]  2253.714134: kvm_entry:            vcpu 1
        qemu-kvm-1863  [008]  2253.714136: kvm_exit:             [FAILED
TO PARSE] exit_reason=44 guest_rip=0xc01185ed isa=1 info1=4272 info2=0
        qemu-kvm-1864  [002]  2253.714138: kvm_exit:             [FAILED
TO PARSE] exit_reason=44 guest_rip=0xc01185ed isa=1 info1=4272 info2=0
        qemu-kvm-1863  [008]  2253.714145: kvm_emulate_insn:     [FAILED
TO PARSE] rip=3222373869 csbase=0 len=2 insn=<89>^H]<C3><8B>^U<EC><95>K<C0>U
<89><E5>]<8D>^E flags=5 failed=0

I have not used trace-cmd much, so I am not familiar with the code. Is
this a known issue? Suggestions on how to debug?

Thanks,
David
