Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab2HTRcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:32:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48953 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab2HTRcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:32:14 -0400
Date: Mon, 20 Aug 2012 19:32:13 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Johannes Goetzfried 
	<Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Tilo =?utf-8?Q?M=C3=BCller?= 
	<tilo.mueller@informatik.uni-erlangen.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH] crypto: twofish - add x86_64/avx assembler implementation
Message-ID: <20120820173213.GD4060@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	Johannes Goetzfried <Johannes.Goetzfried@informatik.stud.uni-erlangen.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Tilo =?utf-8?Q?M=C3=BCller?= <tilo.mueller@informatik.uni-erlangen.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
References: <20120816132926.GB12029@x1.osrc.amd.com>
 <20120817073048.16720.80328.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120817073048.16720.80328.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:37:10AM +0300, Jussi Kivilinna wrote:
> I made few further changes, mainly moving/interleaving 'vmovq/vpextrq'
> ahead so they should be completed before those target registers are
> needed. This only gave 0.5% increase on Sandy-bridge, but might help
> more on Bulldozer.

Here you go:

[   52.282208] 
[   52.282208] testing speed of async ecb(twofish) encryption
[   52.291580] test 0 (128 bit key, 16 byte blocks): 4890079 operations in 1 seconds (78241264 bytes)
[   53.301588] test 1 (128 bit key, 64 byte blocks): 2045945 operations in 1 seconds (130940480 bytes)
[   54.309656] test 2 (128 bit key, 256 byte blocks): 604184 operations in 1 seconds (154671104 bytes)
[   55.317289] test 3 (128 bit key, 1024 byte blocks): 168541 operations in 1 seconds (172585984 bytes)
[   56.325565] test 4 (128 bit key, 8192 byte blocks): 21673 operations in 1 seconds (177545216 bytes)
[   57.333529] test 5 (192 bit key, 16 byte blocks): 4877931 operations in 1 seconds (78046896 bytes)
[   58.341588] test 6 (192 bit key, 64 byte blocks): 2044495 operations in 1 seconds (130847680 bytes)
[   59.349647] test 7 (192 bit key, 256 byte blocks): 604909 operations in 1 seconds (154856704 bytes)
[   60.357533] test 8 (192 bit key, 1024 byte blocks): 167836 operations in 1 seconds (171864064 bytes)
[   61.365545] test 9 (192 bit key, 8192 byte blocks): 21439 operations in 1 seconds (175628288 bytes)
[   62.369497] test 10 (256 bit key, 16 byte blocks): 4907149 operations in 1 seconds (78514384 bytes)
[   63.373535] test 11 (256 bit key, 64 byte blocks): 2060437 operations in 1 seconds (131867968 bytes)
[   64.381620] test 12 (256 bit key, 256 byte blocks): 604784 operations in 1 seconds (154824704 bytes)
[   65.389523] test 13 (256 bit key, 1024 byte blocks): 168547 operations in 1 seconds (172592128 bytes)
[   66.397520] test 14 (256 bit key, 8192 byte blocks): 21682 operations in 1 seconds (177618944 bytes)
[   67.405461] 
[   67.405461] testing speed of async ecb(twofish) decryption
[   67.414776] test 0 (128 bit key, 16 byte blocks): 4903251 operations in 1 seconds (78452016 bytes)
[   68.421569] test 1 (128 bit key, 64 byte blocks): 1979230 operations in 1 seconds (126670720 bytes)
[   69.429644] test 2 (128 bit key, 256 byte blocks): 591549 operations in 1 seconds (151436544 bytes)
[   70.437574] test 3 (128 bit key, 1024 byte blocks): 166478 operations in 1 seconds (170473472 bytes)
[   71.445590] test 4 (128 bit key, 8192 byte blocks): 21441 operations in 1 seconds (175644672 bytes)
[   72.453536] test 5 (192 bit key, 16 byte blocks): 4895430 operations in 1 seconds (78326880 bytes)
[   73.461596] test 6 (192 bit key, 64 byte blocks): 1976120 operations in 1 seconds (126471680 bytes)
[   74.469680] test 7 (192 bit key, 256 byte blocks): 590021 operations in 1 seconds (151045376 bytes)
[   75.477600] test 8 (192 bit key, 1024 byte blocks): 165925 operations in 1 seconds (169907200 bytes)
[   76.485606] test 9 (192 bit key, 8192 byte blocks): 21087 operations in 1 seconds (172744704 bytes)
[   77.493561] test 10 (256 bit key, 16 byte blocks): 4882275 operations in 1 seconds (78116400 bytes)
[   78.501621] test 11 (256 bit key, 64 byte blocks): 1976460 operations in 1 seconds (126493440 bytes)
[   79.509706] test 12 (256 bit key, 256 byte blocks): 591122 operations in 1 seconds (151327232 bytes)
[   80.517617] test 13 (256 bit key, 1024 byte blocks): 166587 operations in 1 seconds (170585088 bytes)
[   81.525606] test 14 (256 bit key, 8192 byte blocks): 21439 operations in 1 seconds (175628288 bytes)
[   82.533520] 
[   82.533520] testing speed of async cbc(twofish) encryption
[   82.547843] test 0 (128 bit key, 16 byte blocks): 5182177 operations in 1 seconds (82914832 bytes)
[   83.557344] test 1 (128 bit key, 64 byte blocks): 1913550 operations in 1 seconds (122467200 bytes)
[   84.565418] test 2 (128 bit key, 256 byte blocks): 540406 operations in 1 seconds (138343936 bytes)
[   85.573320] test 3 (128 bit key, 1024 byte blocks): 141160 operations in 1 seconds (144547840 bytes)
[   86.581346] test 4 (128 bit key, 8192 byte blocks): 17791 operations in 1 seconds (145743872 bytes)
[   87.589283] test 5 (192 bit key, 16 byte blocks): 5167742 operations in 1 seconds (82683872 bytes)
[   88.597316] test 6 (192 bit key, 64 byte blocks): 1913755 operations in 1 seconds (122480320 bytes)
[   89.605689] test 7 (192 bit key, 256 byte blocks): 541933 operations in 1 seconds (138734848 bytes)
[   90.613599] test 8 (192 bit key, 1024 byte blocks): 141155 operations in 1 seconds (144542720 bytes)
[   91.621597] test 9 (192 bit key, 8192 byte blocks): 17652 operations in 1 seconds (144605184 bytes)
[   92.629509] test 10 (256 bit key, 16 byte blocks): 5166590 operations in 1 seconds (82665440 bytes)
[   93.637594] test 11 (256 bit key, 64 byte blocks): 1906451 operations in 1 seconds (122012864 bytes)
[   94.645680] test 12 (256 bit key, 256 byte blocks): 541165 operations in 1 seconds (138538240 bytes)
[   95.653590] test 13 (256 bit key, 1024 byte blocks): 141115 operations in 1 seconds (144501760 bytes)
[   96.661588] test 14 (256 bit key, 8192 byte blocks): 17790 operations in 1 seconds (145735680 bytes)
[   97.669536] 
[   97.669536] testing speed of async cbc(twofish) decryption
[   97.678949] test 0 (128 bit key, 16 byte blocks): 4869673 operations in 1 seconds (77914768 bytes)
[   98.685593] test 1 (128 bit key, 64 byte blocks): 1903734 operations in 1 seconds (121838976 bytes)
[   99.693669] test 2 (128 bit key, 256 byte blocks): 578537 operations in 1 seconds (148105472 bytes)
[  100.701591] test 3 (128 bit key, 1024 byte blocks): 161224 operations in 1 seconds (165093376 bytes)
[  101.709606] test 4 (128 bit key, 8192 byte blocks): 20570 operations in 1 seconds (168509440 bytes)
[  102.717526] test 5 (192 bit key, 16 byte blocks): 4888753 operations in 1 seconds (78220048 bytes)
[  103.725594] test 6 (192 bit key, 64 byte blocks): 1897049 operations in 1 seconds (121411136 bytes)
[  104.733660] test 7 (192 bit key, 256 byte blocks): 576290 operations in 1 seconds (147530240 bytes)
[  105.741572] test 8 (192 bit key, 1024 byte blocks): 160307 operations in 1 seconds (164154368 bytes)
[  106.749588] test 9 (192 bit key, 8192 byte blocks): 20231 operations in 1 seconds (165732352 bytes)
[  107.757500] test 10 (256 bit key, 16 byte blocks): 4900905 operations in 1 seconds (78414480 bytes)
[  108.765608] test 11 (256 bit key, 64 byte blocks): 1913352 operations in 1 seconds (122454528 bytes)
[  109.769683] test 12 (256 bit key, 256 byte blocks): 579791 operations in 1 seconds (148426496 bytes)
[  110.773581] test 13 (256 bit key, 1024 byte blocks): 161259 operations in 1 seconds (165129216 bytes)
[  111.781590] test 14 (256 bit key, 8192 byte blocks): 20569 operations in 1 seconds (168501248 bytes)
[  112.789528] 
[  112.789528] testing speed of async ctr(twofish) encryption
[  112.803833] test 0 (128 bit key, 16 byte blocks): 4524631 operations in 1 seconds (72394096 bytes)
[  113.813345] test 1 (128 bit key, 64 byte blocks): 1929960 operations in 1 seconds (123517440 bytes)
[  114.821706] test 2 (128 bit key, 256 byte blocks): 573250 operations in 1 seconds (146752000 bytes)
[  115.829617] test 3 (128 bit key, 1024 byte blocks): 156671 operations in 1 seconds (160431104 bytes)
[  116.837641] test 4 (128 bit key, 8192 byte blocks): 20175 operations in 1 seconds (165273600 bytes)
[  117.845587] test 5 (192 bit key, 16 byte blocks): 4464459 operations in 1 seconds (71431344 bytes)
[  118.853620] test 6 (192 bit key, 64 byte blocks): 1913816 operations in 1 seconds (122484224 bytes)
[  119.861697] test 7 (192 bit key, 256 byte blocks): 560342 operations in 1 seconds (143447552 bytes)
[  120.869607] test 8 (192 bit key, 1024 byte blocks): 156535 operations in 1 seconds (160291840 bytes)
[  121.877623] test 9 (192 bit key, 8192 byte blocks): 20128 operations in 1 seconds (164888576 bytes)
[  122.885535] test 10 (256 bit key, 16 byte blocks): 4310418 operations in 1 seconds (68966688 bytes)
[  123.893619] test 11 (256 bit key, 64 byte blocks): 1928764 operations in 1 seconds (123440896 bytes)
[  124.901679] test 12 (256 bit key, 256 byte blocks): 573752 operations in 1 seconds (146880512 bytes)
[  125.909600] test 13 (256 bit key, 1024 byte blocks): 157643 operations in 1 seconds (161426432 bytes)
[  126.917597] test 14 (256 bit key, 8192 byte blocks): 20256 operations in 1 seconds (165937152 bytes)
[  127.925536] 
[  127.925536] testing speed of async ctr(twofish) decryption
[  127.934939] test 0 (128 bit key, 16 byte blocks): 4539834 operations in 1 seconds (72637344 bytes)
[  128.941593] test 1 (128 bit key, 64 byte blocks): 1948606 operations in 1 seconds (124710784 bytes)
[  129.949670] test 2 (128 bit key, 256 byte blocks): 579095 operations in 1 seconds (148248320 bytes)
[  130.957604] test 3 (128 bit key, 1024 byte blocks): 157576 operations in 1 seconds (161357824 bytes)
[  131.965614] test 4 (128 bit key, 8192 byte blocks): 20272 operations in 1 seconds (166068224 bytes)
[  132.969540] test 5 (192 bit key, 16 byte blocks): 4543224 operations in 1 seconds (72691584 bytes)
[  133.973612] test 6 (192 bit key, 64 byte blocks): 1937373 operations in 1 seconds (123991872 bytes)
[  134.981681] test 7 (192 bit key, 256 byte blocks): 566959 operations in 1 seconds (145141504 bytes)
[  135.989592] test 8 (192 bit key, 1024 byte blocks): 157951 operations in 1 seconds (161741824 bytes)
[  136.997607] test 9 (192 bit key, 8192 byte blocks): 20148 operations in 1 seconds (165052416 bytes)
[  138.005528] test 10 (256 bit key, 16 byte blocks): 4395855 operations in 1 seconds (70333680 bytes)
[  139.013612] test 11 (256 bit key, 64 byte blocks): 1957802 operations in 1 seconds (125299328 bytes)
[  140.021687] test 12 (256 bit key, 256 byte blocks): 572735 operations in 1 seconds (146620160 bytes)
[  141.029592] test 13 (256 bit key, 1024 byte blocks): 158475 operations in 1 seconds (162278400 bytes)
[  142.037589] test 14 (256 bit key, 8192 byte blocks): 20350 operations in 1 seconds (166707200 bytes)
[  143.045538] 
[  143.045538] testing speed of async lrw(twofish) encryption
[  143.060417] test 0 (256 bit key, 16 byte blocks): 3264161 operations in 1 seconds (52226576 bytes)
[  144.069309] test 1 (256 bit key, 64 byte blocks): 1554828 operations in 1 seconds (99508992 bytes)
[  145.077289] test 2 (256 bit key, 256 byte blocks): 489501 operations in 1 seconds (125312256 bytes)
[  146.085306] test 3 (256 bit key, 1024 byte blocks): 136369 operations in 1 seconds (139641856 bytes)
[  147.093313] test 4 (256 bit key, 8192 byte blocks): 17659 operations in 1 seconds (144662528 bytes)
[  148.101258] test 5 (320 bit key, 16 byte blocks): 3212599 operations in 1 seconds (51401584 bytes)
[  149.109301] test 6 (320 bit key, 64 byte blocks): 1592816 operations in 1 seconds (101940224 bytes)
[  150.117375] test 7 (320 bit key, 256 byte blocks): 484266 operations in 1 seconds (123972096 bytes)
[  151.125583] test 8 (320 bit key, 1024 byte blocks): 136324 operations in 1 seconds (139595776 bytes)
[  152.133598] test 9 (320 bit key, 8192 byte blocks): 17409 operations in 1 seconds (142614528 bytes)
[  153.141528] test 10 (384 bit key, 16 byte blocks): 3341384 operations in 1 seconds (53462144 bytes)
[  154.149595] test 11 (384 bit key, 64 byte blocks): 1568609 operations in 1 seconds (100390976 bytes)
[  155.157663] test 12 (384 bit key, 256 byte blocks): 489544 operations in 1 seconds (125323264 bytes)
[  156.165591] test 13 (384 bit key, 1024 byte blocks): 136252 operations in 1 seconds (139522048 bytes)
[  157.169586] test 14 (384 bit key, 8192 byte blocks): 17666 operations in 1 seconds (144719872 bytes)
[  158.173527] 
[  158.173527] testing speed of async lrw(twofish) decryption
[  158.182931] test 0 (256 bit key, 16 byte blocks): 3299986 operations in 1 seconds (52799776 bytes)
[  159.189595] test 1 (256 bit key, 64 byte blocks): 1483669 operations in 1 seconds (94954816 bytes)
[  160.197584] test 2 (256 bit key, 256 byte blocks): 473621 operations in 1 seconds (121246976 bytes)
[  161.205593] test 3 (256 bit key, 1024 byte blocks): 134830 operations in 1 seconds (138065920 bytes)
[  162.213607] test 4 (256 bit key, 8192 byte blocks): 17453 operations in 1 seconds (142974976 bytes)
[  163.221562] test 5 (320 bit key, 16 byte blocks): 3451006 operations in 1 seconds (55216096 bytes)
[  164.229605] test 6 (320 bit key, 64 byte blocks): 1438524 operations in 1 seconds (92065536 bytes)
[  165.237585] test 7 (320 bit key, 256 byte blocks): 476321 operations in 1 seconds (121938176 bytes)
[  166.245591] test 8 (320 bit key, 1024 byte blocks): 134740 operations in 1 seconds (137973760 bytes)
[  167.253287] test 9 (320 bit key, 8192 byte blocks): 17135 operations in 1 seconds (140369920 bytes)
[  168.261215] test 10 (384 bit key, 16 byte blocks): 3327948 operations in 1 seconds (53247168 bytes)
[  169.269284] test 11 (384 bit key, 64 byte blocks): 1477492 operations in 1 seconds (94559488 bytes)
[  170.277265] test 12 (384 bit key, 256 byte blocks): 476087 operations in 1 seconds (121878272 bytes)
[  171.285263] test 13 (384 bit key, 1024 byte blocks): 134794 operations in 1 seconds (138029056 bytes)
[  172.293260] test 14 (384 bit key, 8192 byte blocks): 17417 operations in 1 seconds (142680064 bytes)
[  173.301199] 
[  173.301199] testing speed of async xts(twofish) encryption
[  173.314784] test 0 (256 bit key, 16 byte blocks): 3098318 operations in 1 seconds (49573088 bytes)
[  174.321306] test 1 (256 bit key, 64 byte blocks): 1566215 operations in 1 seconds (100237760 bytes)
[  175.329692] test 2 (256 bit key, 256 byte blocks): 506626 operations in 1 seconds (129696256 bytes)
[  176.337596] test 3 (256 bit key, 1024 byte blocks): 147735 operations in 1 seconds (151280640 bytes)
[  177.345602] test 4 (256 bit key, 8192 byte blocks): 19329 operations in 1 seconds (158343168 bytes)
[  178.353549] test 5 (384 bit key, 16 byte blocks): 3100328 operations in 1 seconds (49605248 bytes)
[  179.361609] test 6 (384 bit key, 64 byte blocks): 1565733 operations in 1 seconds (100206912 bytes)
[  180.369684] test 7 (384 bit key, 256 byte blocks): 505319 operations in 1 seconds (129361664 bytes)
[  181.373602] test 8 (384 bit key, 1024 byte blocks): 147921 operations in 1 seconds (151471104 bytes)
[  182.377597] test 9 (384 bit key, 8192 byte blocks): 19357 operations in 1 seconds (158572544 bytes)
[  183.385517] test 10 (512 bit key, 16 byte blocks): 3174613 operations in 1 seconds (50793808 bytes)
[  184.393594] test 11 (512 bit key, 64 byte blocks): 1574183 operations in 1 seconds (100747712 bytes)
[  185.401652] test 12 (512 bit key, 256 byte blocks): 508311 operations in 1 seconds (130127616 bytes)
[  186.409563] test 13 (512 bit key, 1024 byte blocks): 148226 operations in 1 seconds (151783424 bytes)
[  187.417570] test 14 (512 bit key, 8192 byte blocks): 19354 operations in 1 seconds (158547968 bytes)
[  188.425520] 
[  188.425520] testing speed of async xts(twofish) decryption
[  188.434933] test 0 (256 bit key, 16 byte blocks): 2984374 operations in 1 seconds (47749984 bytes)
[  189.441610] test 1 (256 bit key, 64 byte blocks): 1391229 operations in 1 seconds (89038656 bytes)
[  190.449590] test 2 (256 bit key, 256 byte blocks): 491896 operations in 1 seconds (125925376 bytes)
[  191.457597] test 3 (256 bit key, 1024 byte blocks): 146033 operations in 1 seconds (149537792 bytes)
[  192.465606] test 4 (256 bit key, 8192 byte blocks): 19087 operations in 1 seconds (156360704 bytes)
[  193.473507] test 5 (384 bit key, 16 byte blocks): 2992604 operations in 1 seconds (47881664 bytes)
[  194.481601] test 6 (384 bit key, 64 byte blocks): 1390541 operations in 1 seconds (88994624 bytes)
[  195.489573] test 7 (384 bit key, 256 byte blocks): 492459 operations in 1 seconds (126069504 bytes)
[  196.497591] test 8 (384 bit key, 1024 byte blocks): 146036 operations in 1 seconds (149540864 bytes)
[  197.505598] test 9 (384 bit key, 8192 byte blocks): 19026 operations in 1 seconds (155860992 bytes)
[  198.513517] test 10 (512 bit key, 16 byte blocks): 2961196 operations in 1 seconds (47379136 bytes)
[  199.521593] test 11 (512 bit key, 64 byte blocks): 1398191 operations in 1 seconds (89484224 bytes)
[  200.529575] test 12 (512 bit key, 256 byte blocks): 496017 operations in 1 seconds (126980352 bytes)
[  201.537574] test 13 (512 bit key, 1024 byte blocks): 146297 operations in 1 seconds (149808128 bytes)
[  202.545571] test 14 (512 bit key, 8192 byte blocks): 19039 operations in 1 seconds (155967488 bytes)

-- 
Regards/Gruss,
Boris.
